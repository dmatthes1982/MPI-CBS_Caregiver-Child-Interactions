function [ data ] = CARE_calcTtestForContrasts( cfg )
% CARE_calcTtestForContrasts calculates one sample t-tests for the glm 
% contrasts for caregivers and children.
%
% Use as
%   [ data ] = CARE_calcTtestForContrasts( cfg )
%
% The configuration options are
%   cfg.prefix    = CARE or DCARE, defines raw data file prefix (default: CARE)
%   cfg.path      = source path' (i.e. 'F:\CARE\DualfNIRS_CARE_processedData\03_glm\')
%   cfg.session   = session number (default: 1)
%

% Copyright (C) 2018, Trinh Nguyen, Vienna University

% -------------------------------------------------------------------------
% Get and check config options
% -------------------------------------------------------------------------
prefix  = CARE_getopt(cfg, 'prefix', 'CARE');
path    = ft_getopt(cfg, 'path', ...
              'F:\CARE\DualfNIRS_CARE_processed\03_glm\');
            
session = ft_getopt(cfg, 'session', 2);

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
caregiverContrasts = zeros(numOfDyads*16,2);
childContrasts = zeros(numOfDyads*16,2);


for i=1:1:length(listOfDyads)
  filename = sprintf([prefix, '_d%02d_03_glm_%03d.mat'], listOfDyads(i), ...
                    session);
  file = strcat(path, filename);
  fprintf('Load %s ...\n', filename);
  load(file, 'data_glm');
  caregiverContrasts((i*16-16):(i*16),:) = data_glm.sub2.T_contrast;
  childContrasts((i*16-16):(i*16),:) = data_glm.sub1.T_contrast;

  if i == 1
    eventMarkers = data_glm.sub1.eventMarkers;
    channel = data_glm.sub1.channel;
  end
  clear data_glm
end
fprintf('\n');


data.sub1.eventMarkers = eventMarkers;
data.sub1.channel = channel;
data.sub2.eventMarkers = eventMarkers;
data.sub2.channel = channel;
data.dyads = listOfDyads;

end
