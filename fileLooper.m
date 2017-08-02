function [ ] = fileLooper( ~ )

FCSFiles = dir('*.fcs');

nfiles = length(FCSFiles);

data = cell(1, nfiles);

for k = 1:nfiles

   data{k} = FSGate2(FCSFiles(k).name);

end 

end