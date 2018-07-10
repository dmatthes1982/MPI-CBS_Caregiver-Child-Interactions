%% CARE Preprocessing with fNIRS-SPM


%% Step 2
% Calculate optical density changes from light intensity and preprocess
% with MARA and Bandstopfilter (butter), then transform to hemoglobin
% changes

srcFolder = '/Volumes/INTENSO/CARE/DualfNIRS_CARE_rawData/';
sourceList    = dir([srcFolder 'CARE_*']);
sourceList    = struct2cell(sourceList);
sourceList    = sourceList(1,:);
numOfSources  = length(sourceList);

for i=1:numOfSources
 dyad=sourceList(i);

Sub1SrcDir  = strcat(srcFolder, dyad, '/Subject1/');
Sub2SrcDir  = strcat(srcFolder,dyad, '/Subject2/');

Sub1_NIRSFile = strcat(Sub1SrcDir, 'NIRS.mat');
Sub2_NIRSFile = strcat(Sub1SrcDir, 'NIRS.mat');

load(Sub1_NIRSFile{1,1});
y_ch=y;
P_ch=P;
load(Sub2_NIRSFile{1,1});
y_cg=y;
P_cg=P;

% Function to calculate optical density data
[Y_ch.od, P_ch] = spm_fnirs_calc_od(y_ch, P_ch);
[Y_cg.od, P_cg] = spm_fnirs_calc_od(y_cg, P_cg);



% Conversion to hemoglobin changes
%P = spm_fnirs_specify_params(P);
P_ch.wav= [760 840];
P_ch.age= 5; 
P_ch.d = 3;
P_ch.acoef = [1.4033    3.8547; 2.5488    1.7990];
P_ch.dpf = [5.5067 4.6881];

P_cg.wav= [760 840];
P_cg.age= 36;
P_cg.d = 3;
P_cg.acoef = [1.4033    3.8547; 2.5488    1.7990];
P_cg.dpf = [5.5067 4.6881];

[Y_ch.hbo, Y_ch.hbr, Y_ch.hbt] = spm_fnirs_calc_hb(Y_ch.fy, P_ch);
[Y_cg.hbo, Y_cg.hbr, Y_cg.hbt] = spm_fnirs_calc_hb(Y_cg.fy, P_cg);


% save files
    P_ch.fname.nirs = fullfile(Sub1SrcDir, 'NIRS.mat');
    save(P_ch.fname.nirs{1,1}, 'Y_ch', 'P_ch'); 
    P_cg.fname.nirs = fullfile(Sub2SrcDir, 'NIRS.mat');
    save(P_cg.fname.nirs{1,1}, 'Y_cg', 'P_cg'); 
    
end
