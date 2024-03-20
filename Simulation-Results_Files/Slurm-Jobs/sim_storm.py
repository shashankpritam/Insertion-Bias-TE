# Imports
import argparse
import random
import time
import math
import os
import subprocess
import shutil
from pathlib import Path

# Path where the main is currently in my system
invade_path = os.path.join(".", "main")

# Parser info
parser = argparse.ArgumentParser(description="""           
Description
-----------
     ___ _   ___     ___    ____  _____ ____  ___  
    |_ _| \ | \ \   / / \  |  _ \| ____/ ___|/ _ \ 
     | ||  \| |\ \ / / _ \ | | | |  _|| |  _| | | |
     | || |\  | \ V / ___ \| |_| | |__| |_| | |_| |
    |___|_| \_|  \_/_/   \_\____/|_____\____|\___/ 

    Simulation Storm""",
    formatter_class=argparse.RawDescriptionHelpFormatter,
    epilog="""
Prerequisites
-------------
    python version 3+

Authors
-------
    Robert Kofler
    Filip Wierzbicki
    Almorò Scarpa
    Shashank Pritam
""")


# Get current time
def current_milli_time():
    return round(time.time() * 1000)

# Generate random bias in range of (-100, 100)
def get_rand_bias():
    return random.randint(-100, 100)


def get_default_output_directory(output_dir=None):
    if output_dir is not None:
        return output_dir

    current_time = time.strftime("%dth%b%yat%I%M%S%p", time.gmtime())
    base_path = Path.cwd()
    default_output_directory = base_path / current_time

    try:
        default_output_directory.mkdir(parents=True, exist_ok=True)
    except Exception as e:
        print(f"Failed to create directory {default_output_directory}: {e}")
        return None

    return str(default_output_directory)


# Parser arguments
parser = argparse.ArgumentParser()

parser.add_argument("--number", type=int, dest="count", default=100, help="the number of simulations")
parser.add_argument("--threads", type=int, dest="threads", default=4, help="the threads of simulations")
parser.add_argument("--output", type=str, dest="output", default=None, help="the output directory for simulations")
parser.add_argument("--invade", type=str, dest="invade", default=invade_path, help="the invade.go")
parser.add_argument("--rep", type=int, dest="rep", default=1, help="the number of replications")
parser.add_argument("--u", type=float, dest="u", default=0.1, help="transposition rate; probability that a TE generates a novel copy")
parser.add_argument("--steps", type=int, dest="steps", default=5000, help="the number of steps")
parser.add_argument("--N", type=int, dest="N", default=1000, help="population size")
parser.add_argument("--gen", type=int, dest="gen", default=5000, help="number of generations")
parser.add_argument("--silent", action="store_true", dest="silent", default=False, help="be quiet; default=False")

args = parser.parse_args()


# The basic command line input for invadego which will have some parameters appended later on
def get_basis(invade):
    return f'{invade} -no-x-cluins --N {args.N} --gen {args.gen} --genome mb:10,10,10,10,10 --x 0.01 --rr 4,4,4,4,4 --rep {args.rep} --u {args.u} --steps {args.steps} --silent'


# Removing irrelavant lines from putput files
def get_filter():
    return """|grep -v "^Invade"|grep -v "^#" """

# Getting random cluter insertions values in the range of (3% to 97%)
def get_rand_clusters(): 
    lower_limit = 0  # Lower bound
    upper_limit = math.log10(1e+4)  # Upper bound, note the cluster size is in kb
    r = math.floor(10**random.uniform(lower_limit, upper_limit))
    return f"{r},{r},{r},{r},{r}"


# TE invasion that is stopped by cluster insertions and neg selection against TEs
def run_cluster_negsel(invade, count, output):
    """
    TE invasion that is stopped by cluster insertions and neg selection against TEs
    """
    commandlist = []
    for i in range(count):
        x = get_rand_clusters()
        tr = current_milli_time() + i
        sampleid_value = x.split(',')[0]
        command_basis = get_basis(invade)
        command = f'{command_basis} --basepop "100({get_rand_bias()})" --cluster kb:{x} --replicate-offset {i} --seed {tr} '
        command += f'--sampleid {sampleid_value} {get_filter()} > {os.path.join(output, str(i))}.txt'
        commandlist.append(command)
    return commandlist

# Construct the command list
output_directory = get_default_output_directory(args.output)
commandlist = run_cluster_negsel(args.invade, args.count, output_directory)


# Submit Jobs
def submit_job_max_len(commandlist, max_processes):
    sleep_time = 10.0
    processes = list()
    for command in commandlist:
        if not args.silent:
            print(f'Running process. \nSubmitting {command}')
        processes.append(subprocess.Popen(command, shell=True, stdout=None))
        while len(processes) >= max_processes:
            time.sleep(sleep_time)
            processes = [proc for proc in processes if proc.poll() is None]
    while len(processes) > 0:
        time.sleep(sleep_time)
        processes = [proc for proc in processes if proc.poll() is None]



print(f"""Running Simulations with the following parameters:
Number of simulations: {args.count}
Number of threads: {args.threads}
Output directory: {args.output}
Invade path: {args.invade}
Number of replications (--rep): {args.rep}
Transposition rate (--u): {args.u}
Number of steps (--steps): {args.steps}
Population size (--N): {args.N}
Number of generations (--gen): {args.gen}
Silent mode: {args.silent}
""")


# This is the "main"
submit_job_max_len(commandlist, max_processes=args.threads)


# Cat 🐈 all the files together:
with open(f"{output_directory}/combined.txt", "wb") as outfile:
    for i in range(args.count):
        filename = f"{args.output}/{i}.txt"
        with open(filename, 'rb') as infile:
            shutil.copyfileobj(infile, outfile)

# Sign of completion of the job.
print("Done")
