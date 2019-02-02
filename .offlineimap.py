#! /usr/bin/env python2
from subprocess import check_output

def getpass(account):
    return check_output("/home/sdf/bin/secret "+account, shell=True).strip("\n")
