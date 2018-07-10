function [data] = care_spmfnirs_preproc( cfg, data )
% care_spmfnirs_preproc does the general preprocessing of the fnirs data. The
% function includes the following steps
%   * Conversion from wavelength data to optical density
%   * MARA motion correction
%   * Pulse quality check
%   * Removing of bad channels
%   * Bandpass filtering
%   * Conversion from optical density to changes in concentration (HbO, HbR and HbT)
%
% Use as
%   care_spmfnirs_preproc( cfg, data )
%
% where the input data has to be the result from care_spmfnirs_NIRxtoSPM 
%
% The configuration options are
%   cfg.pulseQualityCheck = apply visual pulse quality check, 'yes' or 'no', (default: 'yes')
%
% TODO: Fix or remove application of enPruneChannels.
%
% SEE also HMRINTENSITY2OD, ENPRUNECHANNELS, HMRMOTIONCORRECTWAVELET,
% HMRMOTIONARTIFACT, HMRBANDPASSFILT, HMROD2CONC, CARE_XUCHECKDATAQUALITY

% Copyright (C) 2017-2018, Daniel Matthes, MPI CBS, Trinh Nguyen, Univie

% -------------------------------------------------------------------------
% Get and check config options
% -------------------------------------------------------------------------
%cfg.XuCuiQualityCheck = CARE_getopt(cfg, 'XuCuiQualityCheck', 'no');
cfg.pulseQualityCheck = CARE_getopt(cfg, 'pulseQualityCheck', 'yes');

% -------------------------------------------------------------------------
% Preprocessing
% -------------------------------------------------------------------------
fprintf('<strong>Preproc subject 1...</strong>\n');
data.sub1 = preproc( cfg, data.sub1 );
fprintf('<strong>Preproc subject 2...</strong>\n');
data.sub2 = preproc( cfg, data.sub2 );

end

% -------------------------------------------------------------------------
% Local functions
% -------------------------------------------------------------------------
function data = preproc( mainCfg, data )

% convert the wavelength data to optical density
cfg = [];
cfg.info = 'Wavelength to Optical Density';
data.cfg = cfg;
data.fs  = 7.8125;
data.yod = spm_fnirs_calc_od( data.y );                           

% checking for bad channels and removing them (SD.MeasListAct has zeros 
% input for bad channels)
% cfg = [];
% cfg.info      = 'Removing bad channels by enPruneChannels()';
% cfg.tInc      = ones(size(data.aux,1),1);                                                 
% cfg.dRange    = [0 10000000];
% cfg.SNRthresh = 2;
% cfg.resetFlag = 0;
% cfg.previous  = data.cfg;
% data.cfg      = cfg;
% data.SD       = enPruneChannels(data.d, data.SD, cfg.tInc, cfg.dRange,...
%                                 cfg.SNRthresh, cfg.resetFlag);

% correcting for motion artifacts using Wavelet-based motion correction.                                
%cfg = [];
%cfg.info            = 'Wavelet-based motion artifact correction';
%cfg.iQr             = 1.5;                                                  % iqr of 0.5 for infant data recommended
%cfg.previous        = data.cfg;
%data.cfg            = cfg;
%[~, data.dod_corr]  = evalc(...                                             % evalc supresses annoying fprintf output of hmrMotionCorrectWavelet
%                'hmrMotionCorrectWavelet(data.dod, data.SD, cfg.iQr);');

% Apply MARA for motion artifact correction
% identify channels of interest 

mask = ones(1, 16); 
ch_roi = find(mask ~= 0); 

% display time series of fNIRS data
% spm_fnirs_viewer_timeseries(Y_ch, P, [], ch_roi);

    chs = ch_roi;
    cfg.M.chs = chs;
    cfg.M.L = 1;
    cfg.M.th = 3;
    cfg.M.alpha = 5;
    %cfg.C.type = 'Band-stop filter';
    %cfg.C.cutoff = [0.12 0.35; 0.7 1.5];                                     % '[0.12 0.35; 0.7 1.5]'
    %cfg.D.type = 'no';
    cfg.fs = 7.8125;


    
[data.procd, cfg] = care_spmfnirs_MARA(data.yod,... 
                            cfg); 



% run pulse quality check
if strcmp(mainCfg.pulseQualityCheck, 'yes')
  cfg = [];
  cfg.info      = 'Pulse quality check';
  cfg.previous  = data.cfg;
  data.cfg      = cfg;
  fprintf('Pulse quality check. Please select bad channels, in which pulse is not visible!\n');
  data.badChannelsPulse = CARE_pulseQualityCheck(data.procd, data.SD,... % run pulse quality check on all channels 
                                                 data.t);                         
end

% bandpass filtering
cfg = [];
cfg.info            = 'Bandpass filtering';
cfg.lpf             = 0.5;                                                  % in Hz
cfg.hpf             = 0.02;                                                 % in Hz
cfg.fs              = 7.8125;
cfg.previous        = data.cfg;
data.cfg            = cfg;
data.filtd  = hmrBandpassFilt(data.procd, cfg.fs, cfg.hpf, ...
                                      cfg.lpf);

% convert changes in OD to changes in concentrations (HbO, HbR, and HbT)
cfg = [];
cfg.info      = 'Optical Density to concentrations (HbO, HbR, and HbT)';
%cfg.ppf      = [6 6];                                                       % partial pathlength factors for each wavelength.
cfg.wav= [760 840];
sub=data.SD.sub;
if  sub==1
    cfg.age= 5; 
else 
    cfg.age= 36;
end

cfg.d = 3;
cfg.acoef = [1.4033    3.8547; 2.5488    1.7990];
cfg.dpf = [5.5067 4.6881];
cfg.previous  = data.cfg;
data.cfg      = cfg;

[data.hbo,data.hbr,data.hbt] = spm_fnirs_calc_hb(data.filtd, cfg);
%data.dc       = hmrOD2Conc(data.filtd, data.SD, cfg.ppf);

% extract hbo and hbr
%data.hbo = squeeze(data.dc(:,1,:));
%data.hbr = squeeze(data.dc(:,2,:));

% run Xu's bad channel check
%if strcmp(mainCfg.XuCuiQualityCheck, 'yes')
%  cfg = [];
%  cfg.info      = 'Xu Cui data quality check';
%  cfg.previous  = data.cfg;
%  data.cfg      = cfg;
%  data.badChannelsCui = CARE_XuCheckDataQuality(data.hbo, data.hbr);        % run Xu Cui quality check on all channels
%end

% reject bad channels, set all values to NaN
%if strcmp(mainCfg.pulseQualityCheck, 'yes')  
%  if ~isempty(data.badChannelsPulse)
%    fprintf('Reject bad Channels (pulseQualityCheck), set all values to NaN\n');
%    data.hbo(:, data.badChannelsPulse) = NaN;
%    data.hbr(:, data.badChannelsPulse) = NaN;
%  end
%end

%if strcmp(mainCfg.XuCuiQualityCheck, 'yes')
%  if ~isempty(data.badChannelsCui)
%    fprintf('Reject bad Channels (XuCuiQualityCheck), set all values to NaN\n');
%    data.hbo(:, data.badChannelsCui) = NaN;
%    data.hbr(:, data.badChannelsCui) = NaN;
%  end
%end

data = rmfield(data, 'aux');                                                % remove field aux from data structure

end
