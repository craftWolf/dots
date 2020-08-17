#!/bin/python

#
# dotmirror - mirror dotfiles to a local repository
# (c) charlotte 2020
#  

import os.path
import subprocess
from datetime import datetime
from os import environ as env

# Shorthand for env['HOME'] aka $HOME
HOME = env['HOME']
sync_dirs = []

def parse_paths():
    paths = []
    with open('paths') as paths_file:
        for line in paths_file.readlines():
            (path, name) = line.split('\t') # tab seperated
            
            # Do some interpolation
            path = path.replace('$HOME', HOME)

            # ... and remove line endings from the name
            name = name.strip('\n')
        
            paths.append((path, name))
    
    return paths

def create_repo():
    if not os.path.isdir('.git'):
        # Create the repository
        subprocess.call(['git', 'init'])
        print('Initialized new Github repository! (step 1/2)')

        subprocess.call(['mkdir', 'mirror'])
    else:
        print('Cannot create repo, there is already one existing!')
        return

def mirror_dir(dirname: str):
    # Copy the directory into the local mirror folder made above
    # in create_repo function.
    print(f'Copy directory ({dirname}) to local mirror directory (step 2/2)')

    if not os.path.isdir('mirror'):
        subprocess.call(['mkdir', '-p', f'mirror/{dirname}'])

    # Find the target we need to mirror
    target = None
    for (path,name) in sync_dirs:
        if name == dirname:
            target = (path, name)
            break

    (path, name) = target
    subprocess.call(['cp', '-rf', f'{path}', f'mirror/{name}'])

    # Add it to the repo
    subprocess.call(['git', 'add', f'mirror/{name}'])

if __name__ == '__main__':
    print('Parsing paths file')
    sync_dirs = parse_paths()

    create_repo()

    for (_,name) in sync_dirs:
        mirror_dir(name)

    now = datetime.now()
    time = now.strftime('%x %X')
    commit_message = f'Mirror of dotfiles ({time})'
    
    # Commit
    subprocess.call(['git', 'commit', '-m', commit_message])

    # Push!
    subprocess.call(['git', 'push', 'origin', 'master'])
