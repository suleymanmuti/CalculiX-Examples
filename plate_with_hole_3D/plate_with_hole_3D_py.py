#!/usr/bin/python
import os

os.system("cgx -bg plate_with_hole_3D_pre.fbd")
os.system("ccx plate_with_hole_3D")
os.system("cgx -bg plate_with_hole_3D_post.fbd")
