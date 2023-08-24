#!/bin/bash
#PBS -N pop_simulation_job
#PBS -o pop_simulation_output.log
#PBS -e pop_simulation_error.log
#PBS -l nodes=1:ppn=4,mem=64gb
#PBS -l walltime=120:00:00
#PBS -W group_list=x-ccast-prj-ssignor


cd /mmfs1/thunder/home/shashank.pritam/shashank_simulations/invadego

python3 /mmfs1/thunder/home/shashank.pritam/shashank_simulations/invadego/sim_storm.py --N {i} --number 1000 --silent