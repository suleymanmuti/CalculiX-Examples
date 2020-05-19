#!/usr/bin/python
import os

os.system("cgx -bg 2d_turbine_disk_pre.fbd")
os.system("ccx 2d_turbine_disk")
os.system("cgx -bg 2d_turbine_disk_post.fbd")
