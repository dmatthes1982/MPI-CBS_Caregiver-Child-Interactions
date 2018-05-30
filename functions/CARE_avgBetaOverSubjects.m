function [ data ] = CARE_avgBetaOverSubjects( cfg )
% CARE_AVGBETAOVERSUBJECTS estimates the average of the beta values within
% the different conditions over caregivers and over childs.
%
% Use as
%   [ data ] = CARE_avgBetaOverSubjects( cfg )
%
% The configuration options are
%   cfg.prefix    = CARE or DCARE, defines raw data file prefix (default: CARE)
%   cfg.path      = source path' (i.e. '/data/pt_01867/fnirsData/DualfNIRS_CARE_processedData/03_glm/')
%   cfg.session   = session number (default: 1)
%
% See also CARE_GLM

% Copyright (C) 2017-2018, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% Get and check config options
% -------------------------------------------------------------------------
prefix  = CARE_getopt(cfg, 'prefix', 'CARE');
path    = ft_getopt(cfg, 'path', ...
              '/data/pt_01867/fnirsData/DualfNIRS_CARE_processedData/03_glm/');
            
session = ft_getopt(cfg, 'session', 1);

% -------------------------------------------------------------------------
% Select dyads
% -------------------------------------------------------------------------
dyadsList   = dir([path, sprintf([prefix, '_d*_03_glm_%03d.mat'], session)]);
dyadsList   = struct2cell(dyadsList);
dyadsList   = dyadsList(1,:);
numOfDyads  = length(dyadsList);

for i=1:1:numOfDyads
  listOfDyads(i) = sscanf(dyadsList{i}, [prefix, '_d%d_03_glm_', ...
                                   sprintf('%03d.mat', session)]);          %#ok<AGROW>
end

y = sprintf('%d ', listOfDyads);
selection = false;

while selection == false
  fprintf('The following dyads are available: %s\n', y);
  x = input('Which dyads should be included into the averaging? (i.e. [1,2,3]):\n');
  if ~all(ismember(x, listOfDyads))
    cprintf([1,0.5,0], 'Wrong input!\n');
  else
    selection = true;
    listOfDyads = x;
  end
end
fprintf('\n');

% -------------------------------------------------------------------------
% Load and organize data
% -------------------------------------------------------------------------
numOfDyads = length(listOfDyads);
caregiverBeta = zeros(16, 3, numOfDyads);
childBeta = zeros(16, 3, numOfDyads);

caregiverT1 = zeros(16,1,numofDyads);
childT1 = zeros(16,1,numofDyads);
caregiverT2 = zeros(16,1,numofDyads);
childT2 = zeros(16,1,numofDyads);

for i=1:1:length(listOfDyads)
  filename = sprintf([prefix, '_d%02d_03_glm_%03d.mat'], listOfDyads(i), ...
                    session);
  file = strcat(path, filename);
  fprintf('Load %s ...\n', filename);
  load(file, 'data_glm');
  caregiverBeta(:,:,i) = data_glm.sub2.beta;
  childBeta(:,:,i) = data_glm.sub1.beta;
  caregiverT1(:,:,i) = data_glm.sub2.T_collab_contrast;
  childT1(:,:,i) = data_glm.sub1.T_collab_contrast;
  caregiverT2(:,:,i) = data_glm.sub2.T_indiv_contrast;
  childT2(:,:,i) = data_glm.sub1.T_indiv_contrast;
  if i == 1
    eventMarkers = data_glm.sub1.eventMarkers;
    channel = data_glm.sub1.channel;
  end
  clear data_glm
end
fprintf('\n');

% -------------------------------------------------------------------------
% Estimate averaged beta values
% -------------------------------------------------------------------------
fprintf('<strong>Averaging of beta values over caregivers and over childs...</strong>\n\n');
data.sub2.beta = nanmean(caregiverBeta, 3);
data.sub1.beta = nanmean(childBeta, 3);
data.sub2.beta = nanmean(caregiverT1, 3);
data.sub1.beta = nanmean(childT1, 3);
data.sub2.beta = nanmean(caregiverT2, 3);
data.sub1.beta = nanmean(childT2, 3);

data.sub1.eventMarkers = eventMarkers;
data.sub1.channel = channel;
data.sub2.eventMarkers = eventMarkers;
data.sub2.channel = channel;
data.dyads = listOfDyads;

end
