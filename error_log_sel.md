# Session Log: invadego-insertionbias Simulation

---

## Setup Information

* User: shashankpritam@dyn235-237

* Directory: Desktop

* Tool: ./main

* Simulation Parameter

 ``
 N=1000 gen=500 genome="mb:10,10,10,10,10" cluster="kb:300,300,300,300,300" rr="4,4,4,4,4" rep=1000 u=0.1 steps=500 folder="."
 ``


---

## First Attempt

**Command:** `$tool --N 10000 --u 0 -x 0.01 --basepop $folder/input_sel --gen 1000 --genome mb:1 --steps 10 --rr 0 --rep 100`

### Output:

`Invade: 14:08:08 Welcome to InvadeGo InsBias 0.1`

- Using current time as seed: `1684436888961568000`
- Parsing genome definition mb:1. Result: [1000000]
- No piRNA clusters were provided - will not simulate piRNA clusters
- Parsing recombination rates 0. Result: [0] cM/Mb for the different chromosomes
- Setting up environment; genome, piRNA cluster, reference regions, trigger sites, paramutable sites and the recombination rate
- Commencing simulations

### Runtime Error:

- Index out of range [1] with length 0 at invade/io/cmdparser.parseBasepopString

Location: /Users/shashankpritam/Desktop/invadego-insertionbias/io/cmdparser/basepopparser.go:78

---

## Second Attempt

**Command:** `$tool --N 10000 --u 0 -x 0.01 --basepop $folder/input_sel --gen 1000 --genome mb:1 --steps 10 --rr 0 --rep 100`

### Output:

Invade: 14:09:21 Welcome to InvadeGo InsBias 0.1.3
- Using current time as seed: 1684436961994550000
- Parsing genome definition mb:1. Result: [1000000]
- No piRNA clusters were provided - will not simulate piRNA clusters
- Parsing recombination rates 0. Result: [0] cM/Mb for the different chromosomes
- Setting up environment; genome, piRNA cluster, reference regions, trigger sites, paramutable sites and the recombination rate
- Commencing simulations

### Runtime Error:

- Index out of range [1] with length 0 at invade/io/cmdparser.parseBasepopString

Location: /Users/shashankpritam/Desktop/invadego-insertionbias/io/cmdparser/basepopparser.go:78

---

## Third Attempt

**Command:** `$tool --N 10000 --u 0 -x 0.01 --basepop $folder/input_sel --gen 1000 --genome mb:1 --steps 10 --rr 0 --rep 100`

### Output:

Invade: 14:20:02 Welcome to InvadeGo InsBias 0.1.3
- Using current time as seed: 1684437602956990000
- Parsing genome definition mb:1. Result: [1000000]
- No piRNA clusters were provided - will not simulate piRNA clusters
- Parsing recombination rates 0. Result: [0] cM/Mb for the different chromosomes
- Setting up environment; genome.

#### Environment & Tool Setup
- Directory Change: `cd invadego-insertionbias`
- Tool Definition: `tool="./main"`

#### Simulation Parameters
``
N=1000 gen=500 genome="mb:10,10,10,10,10" cluster="kb:300,300,300,300,300" rr="4,4,4,4,4" rep=1000 u=0.1 steps=500 folder="."
``

#### Initial Tool Execution
Command: `$tool --N 10000 --u 0 -x 0.01 --basepop $folder/input_sel --gen 1000 --genome mb:1 --steps 10 --rr 0 --rep 100`

This led to the invocation of the `InvadeGo InsBias 0.1.3` simulation tool which initialized with the current time as seed. After parsing the genome definition, recombination rates, and setting up environment parameters, the simulation ended with a runtime error, indicating an issue with the base population string parsing.

#### Error Fix Attempts
- Viewed the base population file: `cat $folder/input_sel`
- Modified the base population file: `nano $folder/input_sel`

The tool was then re-executed with the same command. However, the runtime error persisted.

#### Final Error Fix
The base population file was edited again using `nano $folder/input_sel`. Unfortunately, the runtime error persisted in the subsequent execution of the tool. The contents of the base population file were then viewed with `cat $folder/input_sel` and were found to be `10000;`.

### Final State
The issue was not resolved within the given log. The runtime error persisted despite several attempts to rectify the base population file. More troubleshooting would be necessary to fully resolve the issue.