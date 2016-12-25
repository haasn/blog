#!/bin/sh
umask 022
dist/build/blog/blog clean
dist/build/blog/blog watch
