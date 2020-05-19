#!/usr/bin/python
import os

os.system("cgx -bg plate_with_hole_2D_pre.fbd")
os.system("ccx plate_with_hole_2D")
os.system("cgx -bg plate_with_hole_2D_post.fbd")
