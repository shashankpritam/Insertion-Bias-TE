#### Shashank Pritam

# Introduction

In this validation we wanted to test if insertion was correctly implemented.

version: invadego 0.1.3

### Materials & Methods

| Bias  | SampleID | Seed              |
|-------|----------|-------------------|
| -100  | mb100 | 1687986419473565499 |
| -90  | mb90 | 1687986439519204740 |
| -80  | mb80 | 1687986459385010207 |
| -70  | mb70 | 1687986479004319218 |
| -60  | mb60 | 1687986498415164945 |
| -50  | mb50 | 1687986518191731481 |
| -40  | mb40 | 1687986537947039053 |
| -30  | mb30 | 1687986557979563694 |
| -20  | mb20 | 1687986577799895192 |
| -10  | mb10 | 1687986597553426300 |
| 0  | b0 | 1687986617358973799 |
| 10  | b10 | 1687986636894417837 |
| 20  | b20 | 1687986656418196570 |
| 30  | b30 | 1687986677115413538 |
| 40  | b40 | 1687986698520036068 |
| 50  | b50 | 1687986720075130951 |
| 60  | b60 | 1687986741333869430 |
| 70  | b70 | 1687986762991078587 |
| 80  | b80 | 1687986784961325051 |
| 90  | b90 | 1687986806594066852 |
| 100  | b100 | 1687986827704107589 |

## Bash Command for Simulation

```{bash}

tool="./main"
genome="mb:1,1,1,1,1"
cluster="kb:30,30,30,30,30"
rep=100
gen=1
steps=1
folder="Simulation-Results/Insertion-Bias/validation_7"
rr="0,0,0,0,0"

mkdir -p $folder

# Loop over values from -100 to 100 in steps of 10
for j in $(seq -100 10 100)
do
    # Set basepop directly to "1000;j"
    basepop="1000($j)"

    # Assign current counter value to sampleid with descriptive prefix
    if [ $j -ge 0 ]
    then
        sampleid="b${j}"
    else
        sampleid="mb${j#-}"  # Use parameter expansion to remove the negative sign
    fi

    # Run the command and write the output to a file named after the sampleid
    $tool --N 100000 --gen $gen --genome $genome --cluster $cluster --rr $rr --rep $rep --basepop "$basepop" --steps $steps --sampleid $sampleid > "$folder/result_${sampleid}.out"
done

cat result_*.out | grep -v "^Invade" | grep -v "^#" > combined_results.out
```

## Load and Clean Data


```python
import pandas as pd
import plotly.graph_objects as go


# Define column names
column_names = ["rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes", "avpopfreq",
                "fixed", "spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3",
                "avbias", "3tot", "3cluster", "spacer_4", "sampleid"]

# Load DataFrame with column names
df = pd.read_csv('combined_results.out', sep='\t', header=None, names=column_names, usecols=range(21))

# Define replacement dictionary
replace_dict = {"mb100": "-100","mb90": "-90", "mb80": "-80", "mb70": "-70", "mb60": "-60",
                "mb50": "-50", "mb40": "-40", "mb30": "-30", "mb20": "-20",
                "mb10": "-10", "b100": "100","b90": "90", "b80": "80", "b70": "70",
                "b60": "60", "b50": "50", "b40": "40", "b30": "30",
                "b20": "20", "b10": "10", "b0": "0"}

# Apply replacements to 'sampleid' column
df['sampleid'] = df['sampleid'].replace(replace_dict, regex=True)

# Define numeric columns
numeric_columns = ["rep", "gen", "fwte", "avw", "min_w", "avtes", "avpopfreq",
                   "fixed", "fwcli", "avcli", "fixcli",
                   "avbias", "sampleid"]

# Convert the columns to numeric
for col in numeric_columns:
    df[col] = pd.to_numeric(df[col], errors='coerce')
```

## Plot Data

#### Figure 1 

```python
# Define your function
def pc(bias, clufrac):
    genfrac = 1.0 - clufrac
    bias = bias / 100
    clufit = (bias + 1.0) / 2.0
    genfit = 1.0 - clufit
    totfit = clufrac * clufit + genfrac * genfit
    p = (clufrac * clufit) / totfit
    return p * 100

# Create a new dataframe where 'gen' == 0 and sort it by 'sampleid'
df2 = df[df['gen'] == 0][numeric_columns].sort_values('sampleid')

# Calculate the expected values (pc) for each 'sampleid'
df2['pc'] = df2['sampleid'].apply(lambda x: pc(x, 0.03))

# Create scatterplot
scatter = go.Scatter(x=df2['sampleid'], 
                     y=df2['avcli'], 
                     mode='markers',
                     name='Observed Value',
                     marker=dict(color="#003f5c"))

# Create line plot with computed 'pc' values
line = go.Scatter(x=df2['sampleid'], 
                  y=df2['pc'], 
                  mode='lines',
                  name='Expected Value',
                  line=dict(color="#ffa600"))

# Create layout
layout = go.Layout(
    title={
        'text': "Average Cluster Insertion across Insertion Bias",
        'y':0.9,
        'x':0.5,
        'xanchor': 'center',
        'yanchor': 'top'},
    xaxis=dict(
        title='Insertion Bias',
        tickmode = 'linear',
        tick0 = -100,
        dtick = 10,
        showgrid=True,
        gridwidth=1,
        gridcolor='LightPink'
    ),
    yaxis=dict(
        title='Average Cluster Insertion / Expected Value',
        showgrid=True,
        gridwidth=1,
        gridcolor='LightPink'
    ),
    plot_bgcolor='rgba(255,255,255,0)',
    font=dict(
        family="Courier New, monospace",
        size=12,  # change font size here
        color="RebeccaPurple"
    )
)

# Combine all elements and plot
fig = go.Figure(data=[scatter, line], layout=layout)

# Export as png
fig.write_image("../../images/2023_06_29_Validation_7a.png")
```




![Validation Plot A](images/2023_06_29_Validation_7a.png "Average Cluster Insertion/Expected Value vs Insertion Bias")

The distribution of average TE (Transposable Elements) insertions across different insertion bias levels for all replicates. The x-axis shows the different Insertion Bias levels ranging from -100 to 100. The y-axis represents the average TE insertions in the piRNA Cluster (Blue Dots for Observed Value and Orange line for Expected value) for each bias level. 

#### Figure 2

```python
# Convert sampleid to numeric
df2['sampleid'] = pd.to_numeric(df2['sampleid'])

# Calculate mean_cli, sd_meancli, pc, and deviation_pc
df_summary = df2.groupby('sampleid')['avcli'].agg(['mean', 'std']).reset_index()
df_summary.columns = ['sampleid', 'mean_cli', 'sd_meancli']
df_summary['pc'] = pc(df_summary['sampleid'], 0.03)
df_summary['deviation_pc'] = df_summary['mean_cli'] - df_summary['pc']

# Create the scatter plot with error bars using Plotly
fig = go.Figure()

# Add the mean_cli and sd_meancli as error bars
fig.add_trace(go.Scatter(
    x=df_summary['sampleid'],
    y=df_summary['mean_cli'],
    error_y=dict(
        type='data',
        array=df_summary['sd_meancli'],
        visible=True
    ),
    mode='markers',
    marker=dict(
        size=6,
        color='blue',
        symbol='circle'
    ),
    name='Mean of Average Cluster Insertion'
))

# Add the expected line
fig.add_trace(go.Scatter(
    x=df_summary['sampleid'],
    y=df_summary['pc'],
    mode='lines',
    line=dict(
        color='red',
        dash='dash'
    ),
    name='Expected Average Cluster Insertion'
))

# Set plot title and labels
fig.update_layout(
    title={
        'text': "Average Cluster Insertion across Insertion Bias",
        'y':0.9,
        'x':0.5,
        'xanchor': 'center',
        'yanchor': 'top'},
    xaxis=dict(
        title='Insertion Bias',
        tickmode = 'linear',
        tick0 = -100,
        dtick = 10,
        showgrid=True,
        gridwidth=1,
        gridcolor='LightPink'
    ),
    yaxis=dict(
        title='Average Cluster Insertion',
        showgrid=True,
        gridwidth=1,
        gridcolor='LightPink'
    ),
    plot_bgcolor='rgba(255,255,255,0)',
    font=dict(
        family="Courier New, monospace",
        size=12,  # change font size here
        color="RebeccaPurple"
    )
)

# Move the legend to the left
fig.update_layout(legend=dict(x=0, y=1))


# Export as png
fig.write_image("../../images/2023_06_29_Validation_7b.png")

```



![Validation Plot B](images/2023_06_29_Validation_7b.png "Average Cluster Insertion (Mean values with SD) across Insertion Bias")

This plot visualizes the mean of Average Cluster Insertion across various Insertion Bias levels, with error bars indicating standard deviation. Unlike previous plot's individual data points, this representation provides a concise summary of the data (mean), making it easier to discern overall trends and reducing the impact of outliers. The expected values are depicted by a dashed red line.

#### Figure 3

```python
# Convert sampleid to numeric
df2['sampleid'] = pd.to_numeric(df2['sampleid'])

# Filter for rep 1
df_rep1 = df2[df2['rep'] == 1]

# Create data frame with bias, theoretical values, and observed values
df_avtes = pd.DataFrame({'bias': df_rep1['sampleid'], 'avtes': df_rep1['avtes']})

# Create scatter plot using Plotly
scatter = go.Scatter(x=df_avtes['bias'], 
                     y=df_avtes['avtes'], 
                     mode='markers',
                     marker=dict(color="#003f5c"))

# Create layout
layout = go.Layout(
    title={
        'text': "Avtes",
        'y':0.9,
        'x':0.5,
        'xanchor': 'center',
        'yanchor': 'top'},
    xaxis=dict(
        title='Insertion Bias',
        tickmode = 'linear',
        tick0 = -100,
        dtick = 10,
        showgrid=True,
        gridwidth=1,
        gridcolor='LightPink'
    ),
    yaxis=dict(
        title='Average TE Insertions',
        showgrid=True,
        gridwidth=1,
        gridcolor='LightPink'
    ),
    plot_bgcolor='rgba(255,255,255,0)',
    font=dict(
        family="Courier New, monospace",
        size=12,
        color="RebeccaPurple"
    )
)

# Combine all elements and plot
fig = go.Figure(data=[scatter], layout=layout)

# Export as png
fig.write_image("../../images/2023_06_29_Validation_7c.png")

```



![Validation Plot C](images/2023_06_29_Validation_7c.png "Average TE Insertions")

Average TE insertions (y-axis) and insertion bias (x-axis) for a single replicate <!-- [['rep'] == 1] -->. The x-axis represents the Insertion Bias varying from -100 to 100. The y-axis depicts the average TE insertions for each bias level. Each data point on the graph represents the average TE insertions for a specific bias level for replicate 1.

#### Figure 4

```python
# Calculate mean and standard deviation of avtes
df_summary_2 = df2.groupby('sampleid')['avtes'].agg(['mean', 'std']).reset_index()
df_summary_2.columns = ['sampleid', 'mean_avtes', 'sd_avtes']

# Create the scatter plot with error bars using Plotly
scatter = go.Scatter(
    x=df_summary_2['sampleid'],
    y=df_summary_2['mean_avtes'],
    error_y=dict(
        type='data',
        array=df_summary_2['sd_avtes'],
        visible=True
    ),
    mode='markers',
    marker=dict(
        size=6,
        color='blue',
        symbol='circle'
    ),
    name='Mean of Average TE Insertions'
)

# Create layout
layout = go.Layout(
    title={
        'text': "Average TE Insertions across Insertion Bias",
        'y':0.9,
        'x':0.5,
        'xanchor': 'center',
        'yanchor': 'top'},
    xaxis=dict(
        title='Insertion Bias',
        tickmode = 'linear',
        tick0 = -100,
        dtick = 10,
        showgrid=True,
        gridwidth=1,
        gridcolor='LightPink'
    ),
    yaxis=dict(
        title='Average TE Insertions',
        showgrid=True,
        gridwidth=1,
        gridcolor='LightPink'
    ),
    plot_bgcolor='rgba(255,255,255,0)',
    font=dict(
        family="Courier New, monospace",
        size=12,
        color="RebeccaPurple"
    ),
    legend=dict(x=0, y=1)  # move the legend to the left
)

# Combine all elements and plot
fig = go.Figure(data=[scatter], layout=layout)

# Export as png
fig.write_image("../../images/2023_06_29_Validation_7d.png")
```




![Validation Plot D](images/2023_06_29_Validation_7d.png "Average TE Insertions mean values across bias")


All replicates' mean average TE insertions (y-axis) against the insertion bias (x-axis). The plot includes error bars, which visually represent the variability in the data by displaying the standard deviation for the average TE insertions at each bias level. 
The x-axis represents the Insertion Bias, which ranges from -100 to 100. The y-axis depicts the mean of the average TE insertions for each bias level. Each data point on the graph represents the mean average TE insertions for a specific bias level across all replicates, with the error bars representing the standard deviation.


# Summary of average cluster insertion statistics

Across the 21 insertion bias values (sampleid 0 to 20), the mean of `cli` is calculated for all 100 replications. The standard deviation is also calculated. We have another column named `pc` which is the theoretical value of average cluster insertion for given insertion bias with 3% cluster size. It was calculated as follows:

```python
# Define your function  
def pc(bias, clufrac):  
    genfrac = 1.0 - clufrac  
    bias = bias / 100  
    clufit = (bias + 1.0) / 2.0  
    genfit = 1.0 - clufit  
    totfit = clufrac * clufit + genfrac * genfit  
    p = (clufrac * clufit) / totfit  
    return p * 100  

# Create a new dataframe where 'gen' == 0 and sort it by 'sampleid'  
df2 = df[df['gen'] == 0][numeric_columns].sort_values('sampleid')  

# Calculate the expected values (pc) for each 'sampleid'  
df2['pc'] = df2['sampleid'].apply(lambda x: pc(x, 0.03))
```
  
The last column, deviation_pc is calculated as the devaiation of mean_cli from pc as:  
  
```python
df_summary['deviation_pc'] = df_summary['mean_cli'] - df_summary['pc']
``` 

  
Overall the df_summary was calculated as below.  

 
```python 
# Convert sampleid to numeric  
df2['sampleid'] = pd.to_numeric(df2['sampleid'])  

# Calculate mean_cli, sd_meancli, pc, and deviation_pc  
df_summary = df2.groupby('sampleid')['avcli'].agg(['mean', 'std']).reset_index()  
df_summary.columns = ['sampleid', 'mean_cli', 'sd_meancli']  
df_summary['pc'] = pc(df_summary['sampleid'], 0.03)  
df_summary['deviation_pc'] = df_summary['mean_cli'] - df_summary['pc']
``` 
  
  
  
| | sampleid | mean\\_cli | sd\\_meancli | pc | deviation\\_pc |  
|:---|:---------|:----------|:------------|:----------|:--------------|  
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

# Conclusion

The validation matches our expectations and the insertion is working as
expected and the the simulation successfully incorporates the user-defined TE insertions as specified.


