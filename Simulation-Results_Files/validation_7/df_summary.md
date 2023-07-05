### Summary of average cluster insertion statistics
—

Across the 21 insertion bias values (sampleid 0 to 20), mean cli is calculated for all 100 replications. Then standard deviation was calculated. We have another column named pc which is the theoretical value of average cluster insertion for  given insertion bias with 3% cluster size. It was calculated as follows: 

<!-- 
Python

\# Define your function  
def pc(bias, clufrac):  
genfrac = 1.0 \- clufrac  
bias = bias / 100  
 clufit = (bias + 1.0) / 2.0  
 genfit = 1.0 \- clufit  
totfit = clufrac * clufit + genfrac * genfit  
p = (clufrac * clufit) / totfit  
return p * 100  
  
\# Create a new dataframe where 'gen' == 0 and sort it by 'sampleid'  
df2 = df\[df\['gen'\] == 0\]\[numeric\_columns\].sort\_values('sampleid')  
  
\# Calculate the expected values (pc) for each 'sampleid'  
df2\['pc'\] = df2\['sampleid'\].apply(lambda x: pc(x, 0.03)) 
-->


The last column, deviation_pc is calculated as the devaiation  of mean_cli from pc as:

<!-- df_summary\['deviation_pc'\] = df_summary\['mean_cli'\] \- df_summary\['pc'\]  -->

Overall the The df_summary was calculated as below.

<!-- 
Python

\# Convert sampleid to numeric  
df2\['sampleid'\] = pd.to_numeric(df2\['sampleid'\])  
  
\# Calculate mean\_cli, sd\_meancli, pc, and deviation_pc  
df_summary = df2.groupby('sampleid')\['avcli'\].agg(\['mean', 'std'\]).reset_index()  
df_summary.columns = \['sampleid', 'mean_cli', 'sd_meancli'\]  
df_summary\['pc'\] = pc(df_summary\['sampleid'\], 0.03)  
df_summary\['deviation_pc'\] = df_summary\['mean_cli'\] \- df_summary\['pc'\] 

-->



|  | sampleid | mean\_cli | sd\_meancli | pc | deviation\_pc |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0 | -100 | 0.0000 | 0.000000 | 0.000000 | 0.000000 |
| 1 | -90 | 0.1617 | 0.012953 | 0.162514 | -0.000814 |
| 2 | -80 | 0.3409 | 0.020405 | 0.342466 | -0.001566 |
| 3 | -70 | 0.5424 | 0.024827 | 0.542823 | -0.000423 |
| 4 | -60 | 0.7688 | 0.029722 | 0.767263 | 0.001537 |
| 5 | -50 | 1.0193 | 0.030691 | 1.020408 | -0.001108 |
| 6 | -40 | 1.3036 | 0.036028 | 1.308140 | -0.004540 |
| 7 | -30 | 1.6341 | 0.041733 | 1.638066 | -0.003966 |
| 8 | -20 | 2.0186 | 0.044767 | 2.020202 | -0.001602 |
| 9 | -10 | 2.4752 | 0.045913 | 2.468007 | 0.007193 |
| 10 | 0 | 2.9907 | 0.051351 | 3.000000 | -0.009300 |
| 11 | 10 | 3.6427 | 0.057099 | 3.642384 | 0.000316 |
| 12 | 20 | 4.4299 | 0.062207 | 4.433498 | -0.003598 |
| 13 | 30 | 5.4413 | 0.070734 | 5.431755 | 0.009545 |
| 14 | 40 | 6.7341 | 0.086071 | 6.730769 | 0.003331 |
| 15 | 50 | 8.4957 | 0.093195 | 8.490566 | 0.005134 |
| 16 | 60 | 11.0005 | 0.099355 | 11.009174 | -0.008674 |
| 17 | 70 | 14.9019 | 0.112139 | 14.912281 | -0.010381 |
| 18 | 80 | 21.7769 | 0.143939 | 21.774194 | 0.002706 |
| 19 | 90 | 37.0244 | 0.164097 | 37.012987 | 0.011413 |
| 20 | 100 | 99.9826 | 0.004845 | 100.0 | -0.0174 |
