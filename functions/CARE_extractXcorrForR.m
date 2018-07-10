for dyad=[2:11 12:23 25:27 29:40 42 44:47]
    ndyad=num2str(dyad);   
    if dyad < 10
        load(['F:\CARE\DualfNIRS_CARE_processed\04_xcorr/CARE_d0',ndyad,'_04_xcorr_001.mat']);
    else
        load(['F:\CARE\DualfNIRS_CARE_processed\04_xcorr/CARE_d',ndyad,'_04_xcorr_001.mat']);
    end

condition=11;                                                               %Condition 11, 12, 13, 14
column = find(ismember(data_xcorr.trialinfo, condition));

for i= 1:length(column)
timeDiff_11(dyad,i*16-15:i*16) = data_xcorr.timeDiff{1, column(i)}
end

condition=12;                                                               %Condition 11, 12, 13, 14
column = find(ismember(data_xcorr.trialinfo, condition));

for i= 1:length(column)
timeDiff_12(dyad,i*16-15:i*16) = data_xcorr.timeDiff{1, column(i)}
end

condition=13;                                                               %Condition 11, 12, 13, 14
column = find(ismember(data_xcorr.trialinfo, condition));

for i= 1:length(column)
timeDiff_13(dyad,i*16-15:i*16) = data_xcorr.timeDiff{1, column(i)}
end

condition=14;                                                               %Condition 11, 12, 13, 14
column = find(ismember(data_xcorr.trialinfo, condition));

for i= 1:length(column)
timeDiff_14(dyad,i*16-15:i*16) = data_xcorr.timeDiff{1, column(i)}
end
end

timeDiff=horzcat(timeDiff_11, timeDiff_12,timeDiff_13);
dlmwrite('\\fs.univie.ac.at\homedirs\nguyenq22\Documents\R\CARE\data/timeDiff.csv',timeDiff)
