#!/bin/sh
umask 022
dist/build/blog/blog clean
dist/build/blog/blog build
chmod -R o+r _site && rsync -rvc _site/ tina:/var/www/html/
git push
