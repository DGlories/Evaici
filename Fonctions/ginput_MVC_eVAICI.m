
function [output, cfg] = ginput_MVC_eVAICI(srate, woi, target, range, method)

% Automatic MVC calculation for eVAICI project - J. Tisseye - June 2022 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% srate: sampling rate in Hz
% woi: window of interest in sec for mean calculation
% target: force target in percentage
% range: force feedback in percentage around the target
% method: 'mean' or 'max' of all selected MVCs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load MVC .mat file
[file, path] = uigetfile('*.mat','Select MVC file','MultiSelect', 'off');
load([path file],'data','labels');
labels = cellstr(labels);

% Figure and axes
Figure = figure('NumberTitle', 'off', 'Name', ['SUBJECT ' file(1:3) ' --> Please select all MVCs of interest and press ENTER ("' method '" method)'],...
    'units','normalized','outerposition',[0 0 1 1]);
Axes_torque = subplot(211,'Parent',Figure);
Axes_ext = subplot(212,'Parent',Figure);
plot(Axes_torque,data(:,5))
legend(Axes_torque,labels{5});
hold(Axes_ext,'on');
plot(Axes_ext,data(:,8),'Color', [0.9290 0.6940 0.1250])
legend(Axes_ext,labels{8})

% Raw torque in Volts
data_force = data(:,5);
if size(data_force,1) > 1
    data_force = data_force';
end

% RMS of TB in Volts
data_EMG = data(:,8);
if size(data_EMG,1) > 1
    data_EMG = data_EMG';
end

% Select MVC of interest
[x,~] = ginput();
locs = sort(round(x));
data_sel = data_EMG;

% Determine flexible index or 4 sec around selected MVC
if (locs(1)-4*srate) < 1
    pts_before = locs(1)-1;
else
    pts_before = 4*srate;
end
if (locs(end)+4*srate) > length(data_sel)
    pts_after = length(data_sel)-locs(end);
else
    pts_after = 4*srate;
end
idx_max = [];
for nn = 1 : numel(locs)
    idx_temp_max = locs(nn)-pts_before:locs(nn)+pts_after;
    idx_max = [idx_max idx_temp_max];
end

% Sliding window to determine mean maximum of window of interest
h = waitbar(0,'','Name',['MVC calculation ("' method '" method)']);
moy_max = [];
for pp = 1:1:(length(idx_max)-woi*srate)
    moy2 = mean(data_sel(:,idx_max(pp):idx_max(pp)+woi*srate));
    moy_max = [moy_max ; moy2];
    waitbar(pp/(length(idx_max)-woi*srate),h,sprintf('%d%s',round(pp/(length(idx_max)-woi*srate)*100),'%'))
end
close(h)

% Find index to calculate mean of window of interest from max or mean MVCs
if strcmp(method,'max')
    locs_max = find(moy_max == max(moy_max));
    pks = moy_max(locs_max);
    idx = idx_max(locs_max):idx_max(locs_max+woi*srate)-1;
elseif strcmp(method,'mean')
    [pks, locs_max] = findpeaks(moy_max,'NPeaks',numel(locs),'MinPeakHeight',0.05,'MinPeakDistance',4*srate);
    if numel(pks) ~= numel(locs)
        error('Ajust "MinPeakHeight" and/or "MinPeakDistance" to find all peaks')
    end
    %     pks <= mean(pks) + 2*std(pks) & pks >= mean(pks) - 2*std(pks)
    %     max(pks) - min(pks)
    idx = [];
    for ii = 1 : numel(locs_max)
        idx_temp = idx_max(locs_max(ii)):idx_max(locs_max(ii)+woi*srate)-1;
        idx = [idx idx_temp];
    end
end

% Set output and cfg
output.indexMVC = idx;
output.moment = mean(data_force(output.indexMVC));
output.EMG = mean(data_EMG(output.indexMVC));
output.feedbak.input = (target/100)*2 * output.EMG;
output.feedbak.range = [((target/100)-(range/100))*output.EMG  ((target/100)+(range/100))*output.EMG];
cfg.file = file;
cfg.srate = srate;
cfg.woi = woi;
cfg.target = target;
cfg.range = range;
cfg.method = method;

% Update plot with MVC selection
for oo = 1 : woi*srate : length(output.indexMVC)
    idx_temp = output.indexMVC(oo:oo+woi*srate-1);
    
    hold(Axes_torque,'on');
    area(Axes_torque,idx_temp,data_force(:,idx_temp),0,'FaceColor',[1 0 0], 'FaceAlpha',0.4) % or [1 0.5 0.2]
    plot(Axes_torque,idx_temp,data_force(:,idx_temp),'r');
    legend(Axes_torque,labels{5},['MVC window (' num2str(woi) ' sec)'])
    
    hold(Axes_ext,'on');
    area(Axes_ext,idx_temp,data_EMG(:,idx_temp),0,'FaceColor',[1 0 0], 'FaceAlpha',0.4) % or [1 0.5 0.2]
    plot(Axes_ext,idx_temp,data_EMG(:,idx_temp),'r');
    legend(Axes_ext,labels{8},['MVC window (' num2str(woi) ' sec)'])
    
    clear idx_temp
end

% Confirm and save
resp = questdlg('Accept and finish?', 'Confirmation','Yes','Redo','Cancel','Yes');
if strcmp(resp,'Yes')
    close(Figure)
    save([path file(1:3) '_MVC_feedback_results.mat'],'output','cfg')
    disp(['Results were saved in ' path file(1:3) '_MVC_feedback_results.mat'])
elseif strcmp(resp,'Redo')
    close(Figure)
    [output, cfg] = ginput_MVC_eVAICI(srate, woi, target, range, method);
else
    return
end

end
