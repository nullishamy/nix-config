#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python39Packages.xdg python39Packages.coloredlogs

import sys
import tempfile
import argparse
import pathlib
import os
import xdg
import shutil
import coloredlogs
import logging
import tarfile
import datetime
import ftplib

PROG_NAME = 'nix-backup'
logger = logging.getLogger(PROG_NAME)

# Default to warn, we will set this if we parse args successfully
coloredlogs.install(level='WARN', logger=logger)

def xdg_dirs():
    dirs = {
        'config': [xdg.xdg_config_home()],
    }

    xdg_extra_dirs = {
        'XDG_DESKTOP_DIR': 'desktop',
        'XDG_PICTURES_DIR': 'pictures',
        'XDG_VIDEOS_DIR': 'videos',
        'XDG_MUSIC_DIR': 'music',
        'XDG_DOCUMENTS_DIR': 'documents'
    }

    try:
        logger.info(f'Beginning parse of user-dirs.dirs')
        with open(os.path.join(xdg.xdg_config_home(), "user-dirs.dirs")) as config_file:
            lines = config_file.readlines()

            for line in lines:
                key, value = line.split('=')
                logger.debug(f'Parsed user-dir line {key} => {value}')

                if key in xdg_extra_dirs:
                    # Strip out the '"' and newlines that are present in the values
                    dirs[xdg_extra_dirs[key]] = [pathlib.Path(value.replace('"', '').strip('\n'))]
                else:
                    logger.debug(f'Ignoring key {key}')
                    pass
    except:
        logger.info('Failed to open user-dirs.dirs, assuming non unix and returning the defaults only')
        return dirs

    return dirs

def parse_args():
    parser = argparse.ArgumentParser(
        prog = PROG_NAME,
        description = 'Backs up relevant files',
    )

    parser.add_argument('--host', help='The host to use for the FTP connection', required=True)
    parser.add_argument('--port', help='The port to use for the FTP connection', required=False, default=21, type=int)
    parser.add_argument('--tarball', help='The existing tarball to use', required=False, type=pathlib.Path)
    parser.add_argument('--exclude-defaults', action='store_true', help='Exclude the default directories from being backed up.', required=False)
    parser.add_argument('--log-level', help='The log level to use', required=False, default='WARN', choices=['DEBUG','INFO','WARN','ERROR','CRITICAL'])
    parser.add_argument('--log-file', help='The log file to use', required=False, type=pathlib.Path)
    parser.add_argument('--archive-dir',  help='The output directory to put the tarballs in.', required=False, default='./archives', type=pathlib.Path)
    parser.add_argument('--retries', help='The amount of retries for FTP', type=int, default=3)
    parser.add_argument('--ftp-dir',  help='The destination directory', required=False, default='Backup')
    parser.add_argument('--username', help='The username to use for the FTP connection', required=False, default='anonymous')
    parser.add_argument('--password', help='The password to use for the FTP connection', required=False, default='anonymous')
    parser.add_argument('--include', help='The additional files / directories to backup', nargs='*', type=pathlib.Path)
    parser.add_argument('--exclude', help='The files / directories to exclude from the backup', nargs='*', type=pathlib.Path)

    return parser.parse_args()

def create_tarball(paths: dict[str, list[pathlib.Path]], output_dir: pathlib.Path, exclude: list[pathlib.Path]) -> pathlib.Path:
    # Create working directory to assemble tarball structure
    work_dir = tempfile.TemporaryDirectory()

    out_paths = {}

    # Copy all files into the working directory
    for dest_dir_name, source_values in paths.items():
        logger.debug(f'Raw dest: {dest_dir_name} Sources: {source_values}')
        dest_dir = pathlib.Path(work_dir.name, dest_dir_name).resolve()
        out_paths.setdefault(dest_dir_name, [])

        for source in source_values:
            skip = False
            for filter in exclude:
                if filter.as_posix() in source.as_posix():
                    skip = True

            if skip:
                logger.info(f'Skipping {source.as_posix()} as it is excluded')
                continue

            logger.info(f'Copying {source.as_posix()} to {dest_dir.as_posix()}')

            if not source.exists():
                logger.error(f'Source {source.as_posix()} does not exist, skipping.')
                continue

            if source.is_dir(): 
                # Enumerate and copy all files
                try:
                    def copy_filter(src, names):
                        ignored = []
                        for filter in exclude:
                            # The whole dir is ignored, just abort
                            if filter == src:
                                return names

                            for raw_name in names:
                                name = pathlib.Path(src, raw_name)
                                if filter.as_posix() in name.as_posix():
                                    logger.debug(f'Skipping {name} as it is excluded')
                                    ignored.append(raw_name)
                        return ignored

                    def copy_function(src, dest):
                        path = shutil.copy2(src, dest)
                        out_paths[dest_dir_name].append(pathlib.Path(path))

                    if dest_dir_name == 'additional':
                        # Put 'additional' items in their own folder, if applicable
                        dest_dir = pathlib.Path(dest_dir, source.name)

                    shutil.copytree(source.resolve(), dest_dir, symlinks=True, ignore=copy_filter, copy_function=copy_function)
                except KeyboardInterrupt:
                    logger.warning('Interrupted whilst preparing tarball, aborting backup')
                    sys.exit(0)

            else:
                # Only copy this one, it's a single file
                try:
                    path = shutil.copy2(source.resolve(), dest_dir)
                except KeyboardInterrupt:
                    logger.warning('Interrupted whilst preparing tarball, aborting backup')
                    sys.exit(0)
                out_paths[dest_dir_name].append(path)

    # Assemble tarball
    logger.info('Assembling tarball')
    timestamp = datetime.datetime.now().strftime('%b%d-%X')
    tar_path = pathlib.Path(output_dir, f'backup-{timestamp}.tar.gz')

    try:
        with tarfile.open(tar_path, 'x:gz') as tarball:
            for pretty_name, tar_paths in out_paths.items():
                for path in tar_paths:
                    logger.debug(f'Adding path {path} to {pretty_name}')
                    tarball.add(path)
    except KeyboardInterrupt :
        logger.warning('Interrupted whilst assembling tarball, cleaning up')
        os.remove(tar_path)
        sys.exit(0)

    return tar_path

def upload_to_ftp(host: str, port: int, username: str, password: str, tarball: pathlib.Path, destination: str, max_attempts, attempts = 1):
    if attempts == max_attempts + 1:
        logger.error(f'FTP timed out after {max_attempts} attempts')
        os.remove(tarball)
        sys.exit(1)

    logger.info(f'Logging in with username {username} on {host}:{port}')
    server = ftplib.FTP()

    try:
        server.connect(host, port)
        server.login(username, password)

        logger.info('Connected!')
        logger.debug(f'Changing to {destination}')

        server.cwd(destination)

        logger.info('Uploading...')
        logger.debug(f'Uploading {tarball.as_posix()}')
        with open(tarball, 'rb') as tar_file:
            server.storbinary(f'STOR {tarball.name}', tar_file)
    except KeyboardInterrupt:
        logger.warning('Interrupted whilst uploading tarball, aborting backup')
            
        try:
            os.remove(tarball)
            server.quit()
        except:
            pass

        sys.exit(0)
    except Exception as err:
        logger.error(f'Failed to upload to FTP, retrying ({attempts}/{max_attempts})', exc_info=err)
        return upload_to_ftp(host, port, username, password, tarball, destination, max_attempts, attempts + 1)

    logger.info('Done! Disconnecting')

    server.quit()

def main():
    args = parse_args()

    coloredlogs.install(level=args.log_level, logger=logger)
    logger.info(f'Installed {args.log_level} logs')

    if args.log_file:
        logger.addHandler(logging.FileHandler(args.log_file))
        logger.debug('Added FileHandler log handler')

    logger.info('Checkpoint 1: Args')

    logger.debug('Setting up file set')

    files = {
        'additional': args.include or []
    }

    if not args.exclude_defaults:
        logger.debug('Including default values')
        # Push xdg dirs into the files
        files.update(xdg_dirs())

    if args.exclude_defaults and len(files['additional']) == 0:
        logger.critical('No files specified for backup (defaults excluded)')
        sys.exit(1)

    logger.debug('Attempting to create archive dir')
    if not os.path.exists(args.archive_dir):
        os.makedirs(args.archive_dir)
        logger.debug('Created archive dir')
    
    if args.tarball:
        tarball = args.tarball.resolve() 
    else:
        tarball = create_tarball(files, args.archive_dir, args.exclude or [])

    logger.debug(f'Tarball path: {tarball.as_posix()}')
    logger.info('Checkpoint 2: Tarball')

    logger.debug('Starting upload process')
    upload_to_ftp(args.host, args.port, args.username, args.password, tarball, args.ftp_dir, args.retries)

    logger.info('Checkpoint 3: FTP')
    logger.info('Backup complete, exiting!')
    sys.exit(0)

if __name__ == '__main__':
    try:
        main()
    except Exception as err:
        logger.critical('An error occured whilst running the script: \n', exc_info=err)



