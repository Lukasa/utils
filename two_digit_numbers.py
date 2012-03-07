#!/usr/bin/env python
# This script is a one-off to place two-digit numbers in filenames.
import os, sys

filedir = os.path.expanduser(sys.argv[1])
if (not filedir[-1] == '/'):
    filedir += '/'
files = os.listdir(filedir)

for item in files:
    name = item.split('.')[0].split('_')
    extn = item.split('.')[1]
    output = []

    for element in name:
        try:
            no = int(element)
            if no < 10:
                output.append('0' + str(no))
            else:
                output.append(str(no))
        except ValueError:
            output.append(element)

    output = '_'.join(output)
    os.rename(filedir + item, filedir + output + '.' + extn)
