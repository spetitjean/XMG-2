#! /usr/bin/python3
# -*- mode:python; coding:utf-8 -*-

import sys
#, argparse, os.path, subprocess, os, xmg.modular_yap

if sys.version_info[0] < 3:
    raise Exception("xmg requires python version 3")

import xmg.command

#==============================================================================
# parse the command line and run the appropriate command
#==============================================================================

def main():
    xmg.command.load_commands()
    args = xmg.command.parser.parse_args()
    args.handler(args)
