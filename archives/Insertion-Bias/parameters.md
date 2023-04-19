Parameters of Invadego (Insertion Bias):

   >N -int
  
    	mandatory; the population size (default -1)
      
  >basepop -string
  
    	mandatory; the segregating insertions in the starting population; either 'count(bias),count(bias)' or file-path; see manual
      
  >clonal
    	
    	clonal propagation; no recombination, no mating
      
  >cluster string
    	
    	piRNA clusters; e.g. 'kb:1,1,1,1' specifies a cluster of 1kb at the beginning of each chromosome
      
  >file-debug string
    	
    	optional output file for debugging various aspects
      
  >file-mhp string
    	
    	optional output file: position and population frequency of each insertion
      
  >file-sfs string
    	
    	optional output file: site frequency spectra of TE insertions
      
  >file-tally string
    	
    	optional output file: count of insertions per individual
      
  > gen int
  
    	mandatory; run the simulations for '--gen' generations (default -1)
      
  > genome string
  
    	mandatory; the genomic landscape; e.g. 'MB:2,3,1,5' specifiies four chromosomes with sizes of 2,3,1,5 Mb
      
  > max-insertions int
  
    	the maximum number of insertions (default 10000)
      
  > min-w float
  
    	the minimum frequency of an average individual in the population (default 0.1)
      
  > mu-bias float
  
    	mutation rate of the bias, the probability that a given TE insertion will mutate its bias; all genomic insertions are considered
      
  > no-x-cluins
  
    	cluster insertions incur no negative effects
      
  > rep int
  
    	the number of replicates (default 1
      
  > replicate-offset int
  
    	starting index of the replicates; may be used for pseudo-parallelization) (default 1)
      
  > rr string
  
    	the recombination rate per chromosome in cm/Mb; e.g. '3,4,4,5' 
      
  > sampleid string
  
    	the ID of the sample; will be a help in R to group samples like with facete_grid()
      
  > seed int
  
    	seed for the random number generator (default -1)
      
  > selective-cluins
  
    	cluster insertions with a given bias will only suppress insertions with the same bias
      
  > silent
  
    	suppress output
      
  > steps int
  
    	report the output at each '--steps' generations (default 20)
      
  > t float
  
    	the synergistic effect of TE insertions (default 1)
      
  > threads int
  
    	number of threads (default 1)
      
  > u float
  
    	the transposition rate
      
  > uc float
  
    	the transposition rate in the presence of piRNAs
      
  > x float
  
    	the deleterious effect of a single TE insertions
