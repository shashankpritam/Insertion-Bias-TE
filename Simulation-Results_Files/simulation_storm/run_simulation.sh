#!/bin/bash
#PBS -N simulation_job
#PBS -o simulation_output.log
#PBS -e simulation_error.log
#PBS -l nodes=1:ppn=4,mem=64gb
#PBS -l walltime=120:00:00
#PBS -W group_list=x-ccast-prj-ssignor


cd /mmfs1/thunder/home/shashank.pritam/shashank_simulations/invadego

python3 /mmfs1/thunder/home/shashank.pritam/shashank_simulations/invadego/sim_storm.py --number 10000 --silent
