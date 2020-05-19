#!/usr/bin/python
import os

os.system("cgx -b rotating_cantilever_beam_pre.fbd")
os.system("ccx rotating_cantilever_beam")
os.system("cgx -b rotating_cantilever_beam_post.frd")



