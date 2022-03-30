#!/usr/bin/python

import os
import glob

outfile = "/data/psychology/sokol-hessnerlab/VNI/FEAT_models_lev2/nameOfModel/lev2_QA.html"

os.system("rm %s"%(outfile))

all_feats = glob.glob('/data/psychology/sokol-hessnerlab/VNI/FEAT_models_lev2/nameOfModel/sub-*.gfeat')

f = open(outfile, "w")
for file in list(all_feats):
  f.write("<p>============================================")
  f.write("<p>%s"%(file))
  f.write("<IMG SRC=\"%s/inputreg/masksum_overlay.png\">"%(file))
  f.write("<IMG SRC=\"%s/inputreg/maskunique_overlay.png\">"%(file))
f.close()
