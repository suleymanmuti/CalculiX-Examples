#!/usr/bin/python
import os

os.system("cgx -bg turbine_disk_3d_pre.fbd")
os.system("ccx turbine_disk_3d")
os.system("cgx -bg turbine_disk_3d_post.fbd")
