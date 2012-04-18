#!/usr/bin/env python
# This script is a one-off to place two-digit numbers in filenames.
import os, sys

try:
    filedir = os.path.expanduser(sys.argv[1])
except IndexError:
    print 'Script must be called with one argument.'
    sys.exit(1)

if (not filedir[-1] == '/'):
    filedir += '/'
files = os.listdir(filedir)

for movie_file in files:
    name = movie_file.split('.')[0].split('_')
    extn = movie_file.split('.')[1]
    output_name = []

    for element in name:
        try:
            number = int(element)
            if number < 10:
                output_name.append('0' + str(number))
            else:
                output_name.append(str(number))
        except ValueError:
            output_name.append(element)

    output_name = '_'.join(output_name)
    os.rename(filedir + movie_file, filedir + output_name + '.' + extn)
