% This is a demo code for basic data quality check.
% 1. Note all the modules added to the nirstoolbox is checking the HB data,
% NOT the raw
% 2. Note all the checking process does not do anything to the data, and
% you can run the data analysis pipeline with bad data QC


%% Define data directory and load raw rataset
%%
clear
datadir =uigetdir();

%load Data
raw = nirs.io.loadDirectory(datadir, {'Subject','Task'});

disp('Converting Optical Density...')
odconv=nirs.modules.OpticalDensity();
od=odconv.run(raw);

disp('Applying  Modified Beer Lambert Law...')
mbll=nirs.modules.BeerLambertLaw();
hb=mbll.run(od);


%% Sanity Check for the stim marks and probesetup
% Stim marks
for i=1:length(raw)
    [filepath,name,ext] = fileparts(raw(i).description);
    disp(strcat('There are',{' '}, num2str(size(raw(i).stimulus.values,2)), ' tasks in',{' '}, name, ext))
end

% Probe setup
for i=1:length(raw)
    disp(strcat('There are',{' '}, num2str(size(raw(i).data,2)/2), ' data channels in',{' '}, name, ext))
end

%% Check the data quality

% SNR----
jsnr=nirs.dataqualitycontrol.SNRCheck();
jsnr.channelofinterest=1;
datasnr=jsnr.run(hb);

% Check HbO HbR Correlation----
jhbc=nirs.dataqualitycontrol.Anti_Corr_Check();
jhbc.channelofinterest=1;
anticorr=jhbc.run(hb);

% Cardiac Spectrum
jcardi=nirs.dataqualitycontrol.Cardiac_Spectrum_Check();
jcardi.checkoption = 1;
jcardi.channelofinterest = 1;
cardi=jcardi.run(hb);

% Singal Variance all channels----
jvar=nirs.dataqualitycontrol.SignalVarianceCheck();
datavar=jvar.run(hb);

% Temporal Derivatives
jd=nirs.dataqualitycontrol.SignalTemporalDerivativesCheck();
jd.lag=7;
dataderivative=jvar.run(hb);

% Motion Artifact
jm=nirs.dataqualitycontrol.MotionArtifactCheck();
motion=jm.run(hb);

% Baseline Shift
jbaseline=nirs.dataqualitycontrol.Baseline_ShiftCheck();
baseshift=jbaseline.run(hb);

