#!/bin/sh
umask 022
dist-newstyle/build/x86_64-linux/ghc-8.10.3/blog-0.1.0.0/x/blog/build/blog/blog rebuild
chmod -R o+r _site && rsync -rvc _site/ tina:/var/www/html/
git push
