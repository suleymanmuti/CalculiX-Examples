#!/usr/bin/python
import os

os.system("cgx -bg blisk_pre.fbd")
os.system("ccx blisk")
os.system("cgx -bg blisk_post.fbd")

