#!/bin/sh
# 
# Automatized CMIP5 ESGF downloading.
#
# Author: Diego Jiménez de la Cuesta Otero (Automatization)
# 
# This script processes a query to download a subset of the CMIP5 database.
# 
# By default it uses the following facets of ESGF:
# 
# project, product, experiment, time_frequency, variable, ensemble and model.
# 
# The script sends to ESGF server in bsurl (base search url) variable a query
# to obtain a wget download scripts, based on the parameters given in cfg, ds,
# projs, prods, exps, freqs, vars, enses and mods variables. The system is
# called RESTful protocol.
# 
# The download will be done inside the basedir directory.
# 
# Description of variables and subvalues:
# 
# cfg:
#  distrib: if the search is done inside a ESGF node or federation wide.
#  latest: if it is requested the latest version of data.
#  limit: the limit of files to be downloaded, 10000 is the maximum.
# 
# ds: determines the directory tree that will be created and in which data will
#     be downloaded.
# 
# projs: In principle, it is fixed to CMIP5. You can switch it to other project
#        or to a list of projects, however maybe you will need to tune
#        something else in the script. However, thanks to RESTful, this is a
#        simple task. Read the FAQ at one of ESGF node sites.
# 
# prods: By default it is set to CMIP5 output1 product. For other products of
#        CMIP5 or of other projects, visit a ESGF node site.
# 
# exps: By default this are experiments within the project and product. Exam-
#       ples are piControl or historical for CMIP5.
# 
# freqs: A list of frequencies at which the output is wanted. Example is mon
#        for monthly data.
# 
# vars: These are the short names of the variables in the context of CMIP5.
#       An example is ts, for the surface temperature.
# 
# enses: These are a chain of the letters r, i and p with numbers between them.
#        r stands for realization, i for initialization and p for physics.
#        The numbers represent which realization, with which initialization and
#        which physics is used. This is the case for CMIP5, for other projects,
#        this may or may not exist. For CMIP5, modeling groups use p1 mostly,
#        with the exception of GISS group, which has several physics settings.
#        This is quite frustrating, since different physics for me counts as
#        another different model. You need to trace this clearly since you can
#        not average models with different physics and expect a model average.
# 
# mods: This is a list of model names.
# 
# From what I said before, it is highly recommended that first you visit ESGF
# website and make the search without downloading and copy the parameters in
# this script.
# 
# The final result will be your data tree without any download scripts remai-
# ning behind, since once a download script has ended its use, it is erased.
# 
# The reason behind the multiple for cycles is that some models tend to have a
# large number of files for a variable in a single experiment realization,
# small chunks of time. Therefore, rapidly the limit of 10000 files could be
# surpassed if downloaded too broadly.
# 
# Take into account that sometimes, some nodes are slow. For example, DKRZ
# node is slow, because data is stored in tape.
# 
# As a final note: you will need an openID from an account of ESGF. First,
# register in a ESGF node. The first time you run a wget download script (not
# necessarily with this script) and if you have installed java, your creden
# tials will be stored in your machine. Otherwise you will need to repeat
# your credentials any time the download scripts be run.
# 
# If you modified the code, please make clear that you modified it, what is the
# modification and include references to me... and, of course, add you as an
# author.
# 
#------------------------------------------------------------------------------
# 
# In the following, in order to use it, substitute the placeholders (e.g.
# <dir>) with the proper information and modify the query for your purpouses.
# 
# There is no other requierement to use this script than recent bash and wget.
# 
#------------------------------------------------------------------------------

basedir=<dir>;

projs="CMIP5";
prods="output1";
exps="piControl abrupt4xCO2 1pctCO2";
freqs="mon";
vars="rlut rsut rsdt ts";
enses="r1i1p1 r1i1p2 r1i1p3 r1i1p4 r1i1p141 r1i1p142";
mods="ACCESS1.3 CCSM4 CNRM-CM5 CNRM-CM5-2 CSIRO-Mk3.6.0 CSIRO-Mk3L-1-2 GISS-E2-H GISS-E2-R HadGEM2-ES INM-CM4 IPSL-CM5A-LR IPSL-CM5A-MR IPSL-CM5B-LR MIROC-ESM MIROC5 MPI-ESM-LR MPI-ESM-MR MPI-ESM-P MRI-CGCM3 NorESM1-M";

bsurl="http://esgf-node.jpl.nasa.gov/esg-search/wget?";
cfg="distrib=true&latest=true&limit=10000&";
ds="download_structure=institute,model,experiment,ensemble&";

burl=${bsurl}${cfg}${ds};

mkdir -p ${basedir};
cd ${basedir};
for pj in ${projs};
 do
  for pd in ${prods};
   do
    for mod in ${mods};
     do
      for exp in ${exps};
       do
        for freq in ${freqs};
         do
          for ens in ${enses};
           do
            for var in ${vars};
             do
              url="${burl}project=${pj}&product=${pd}&model=${mod}&experiment=${exp}&variable=${var}&time_frequency=${freq}&ensemble=${ens}";
              wget -O down.sh ${url};
              bash down.sh;
              rm down.sh
            done
          done
        done
      done
    done
  done
done
