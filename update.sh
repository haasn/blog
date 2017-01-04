#!/bin/sh
umask 022
dist/build/blog/blog rebuild
chmod -R o+r _site && rsync -rvc _site/ tina:/var/www/html/
git push
