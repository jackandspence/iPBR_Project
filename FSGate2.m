%% FSGate Function
% Takes .fcs file as input, returns gated matrix of fcsdat as output
function fcsdat_gated = FSGate2(filename)

%% (A) Raw Data Acquisition & Initial Processing

% Use fca_read function to open file (http://bit.ly/2uWvmwt)
% Store data in matrix called fcsdat, dimensions = (#cells, 7)
fcsdat = fca_readfcs(filename);

% Sort & store first column of forward scatter data (ascending)
fcsdat_raw = sort(fcsdat(:,1));

% Create histogram of only RAW forward scatter data (column 1 of fcsdat)
figure
histogram(fcsdat_raw, 100);
title('Forward Scatter | Raw Data');
xlabel('FSC-A');
ylabel('Cell Count');

%% (B) Determining Initial Trim Sites & Trimming Raw Matrix
% Eliminate noise at lower and higher forward scatter values

% Store lower 50% of data in new array
half_fcsraw = round(length(fcsdat_raw)/2);
lower_50 = fcsdat_raw(1:half_fcsraw);

% Count number of elements in 100 bins of lower 50% of data
binranges = linspace(lower_50(1),lower_50(half_fcsraw),100);
bincounts = histc(lower_50, binranges);

% Find index of minimum of bincounts
min_bincounts = min(bincounts(1:end-1));
min_bincounts_index = find(bincounts==min_bincounts);

% Find bin value that corresponds to min_bincounts_index. Use this value as
% the point to trim the fcsdat matrix
trim_value = binranges(min_bincounts_index);

% Instantiate empty array for range indices
range_indices = [];

% Iterate through elements in 1st column of fcsdat to determine the indices
% of elements that fall within a standard range (trim_value<X<2.5e5) of
% forward scatter values which more likely represent live cells
for i = 1:length(fcsdat(:,1))
    fcsval = fcsdat(i,1);
    if fcsval > trim_value & fcsval < 2.0*10^5
        range_indices(end+1) = i;
    end
end

% Instantiate empty matrix for new, trimmed fcsdat
fcsdat_trimmed = [];

% For-loop to remove elements of fcsdat that ARE NOT part of the range of
% indices as defined by range_indices
for i = range_indices
    fcsdat_trimmed(end+1,:) = fcsdat(i,:);
end

% Create histogram of trimmed forward scatter data
figure
histogram(fcsdat_trimmed(:,1), 100);
title(['Forward Scatter | Trimmed']);
xlabel('FSC-A');
ylabel('Cell Count');

%% (C) Allowing User to Input Gating Parameters & Gating Trimmed Matrix

% Prompt user to input a number between 0 (no gating) and 3 (max gating) to
% indicate the number of standard deviations from the mean of the trimmed
% data he/she would like to gate.
prompt = 'Provide a value from 0 to 3 to indicate desired amt of gating:';
str = input(prompt, 's');
if str2double(str) < 0 || str2double(str) > 3
    disp('Invalid Input; Try again');
else
    deviation = str2double(str)*(std(fcsdat_trimmed(:,1)));
end

% Use selected amount of gating (standard_deviation * user provided value)
% to set gating parameters and create new fcsdat_gated matrix
lower_bound = mean(fcsdat_trimmed(:,1)) - deviation;
upper_bound = mean(fcsdat_trimmed(:,1)) + deviation;

% Instantiate empty array for gating range indices
gated_indices = [];

% Iterate through elements in 1st column of fcsdat_trimmed to determine the
% indices of the elements that fall within lower and upper bounds
for i = 1:length(fcsdat_trimmed(:,1))
    fcsval = fcsdat_trimmed(i,1);
    if fcsval > lower_bound && fcsval < upper_bound
        gated_indices(end+1) = i;
    end
end

% Instantiate empty matrix for new, trimmed fcsdat
fcsdat_gated = [];

% For-loop to remove elements of fcsdat that ARE NOT part of the range of
% indices as defined by range_indices
for i = gated_indices
    fcsdat_gated(end+1,:) = fcsdat_trimmed(i,:);
end

% Create histogram of gated forward scatter data
figure;
histogram(fcsdat_gated(:,1), 100);
title(['Forward Scatter Gated | ',str,' Standard Deviation(s)']);
xlabel('FSC-A');
ylabel('Cell Count');

end