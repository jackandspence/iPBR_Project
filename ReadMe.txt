============================
Automated FACS Data Analyzer
============================

Jackson Allen and Spencer Kiehm
iPBR | Summer 2017

———
WHAT IS THIS?

This set of functions, FSGate2, fca_fcsread, and fileLooper, allow a user to provide .fcs files either individually (via FSGate2) or in a batch (via fileLooper) and manipulate the forward-scatter data of .fcs file(s) to focus on a cell population of interest. FSGate2 is responsible for data manipulation and figure generation, while fileLooper iterates through different .fcs files in the working directory, applying the FSGate2 function to each.

———
HOW TO USE FSGate2

*FSGate2 takes a .fcs file path (or file name, if .fcs file is in the working directory) and returns an edited matrix containing data only from cells in the region of interest, as specified by the user.*

1. Ensure that the fca_fcsread.m, FSGate2.m files and the .fcs file you would like to analyze are in the working directory.

2. Execute the command: output = FSGate2(‘filename’); replacing output with the desired name of your output matrix and filename with the full name of your .fcs file.;

3. The function will generate two histograms, one of the raw forward scatter data and another of the forward scatter data trimmed to eliminate noise in the lower and upper regions of data.

4. The command line will prompt you for a value between 0 and 3. The value you provide will indicate the number of standard deviations from the mean of the trimmed forward scatter data you would like to further trim to zoom in on the data.

5. After providing this value, the function will produce a third histogram of the trimmed forward scatter data (as specified by your choice of value) and a matrix as an output. This matrix contains the gated forward scatter data AND the data for the corresponding parameters for each cell.

———
HOW TO USE fileLooper

*fileLooper is a simple for-loop that determines the number of .fcs files in the working directory, and then performs the FSGate2 function on each of them*

1. Ensure that the fca_fcsread.m, FSGate2.m files and the .fcs files you would like to analyze are in the working directory.

2. Execute the command: output = fileLooper; replacing output with the desired name of your output matrix

	a. fileLooper does not require any inputs to be specified

3. Your data will be stored in the ouput matrix you specified, with each cell containing the data matrix for one .fcs file in your working directory. All of the relevant histograms will be generated as well, allowing you to visualize the gating for each .fcs file.