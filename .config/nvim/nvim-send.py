#!/usr/bin/env python

import neovim
import sys
import os

nvim = neovim.attach('socket', path='{}/tmp/vim-session'.format(os.environ['HOME']))
nvim.command(" ".join(sys.argv[1:]))
