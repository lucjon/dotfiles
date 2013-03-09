#!/usr/bin/env python
## guistart.py
## Handles changing wallpapers, etc. and other GUI startup things

# one of:
#   'random': chooses a random image from the wallpaper directory
#   'index':  chooses the image matching the workspace number
MODE = 'random'

#######
import glob, i3, json, os, random, subprocess
wallpaper_path = os.path.join(os.path.abspath(os.path.dirname(__file__)), 'wallpaper')

def wallpaper_index(num):
	default = os.path.join(wallpaper_path, '1.png')
	we_want = glob.glob(os.path.join(wallpaper_path, '%d.*' % num))

	if len(we_want) == 0:
		return default
	else:
		return we_want[0]

def wallpaper_random(num):
	return random.choice(glob.glob(os.path.join(wallpaper_path, '*')))

def change_wallpaper(event, data, subscription):
	for workspace in data:
		if workspace['visible']:
			path = globals()['wallpaper_' + MODE](workspace['num'])
			subprocess.call(['feh', '--no-fehbg', '--bg-scale', path])
			
if __name__ == '__main__':
	i3.Subscription(change_wallpaper, 'workspace')
