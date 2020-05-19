#!/usr/bin/python
import os

os.system("cgx -bg rotating_disk_axisymmetric_pre.fbd")
os.system("ccx rotating_disk_axisymmetric")
os.system("cgx -bg rotating_disk_axisymmetric_post.fbd")

