% Zero-phase digital filtering with Butterworth design
% Bandpass, band-stop, high-pass and low-pass along the right longest dimension
% Joseph Tisseyre - 2019 february 
function F = butter_filtfilt(NF,srate,order,freq,type)

    if (strcmp(type,'low') || strcmp(type,'high')) && numel(freq) > 1
        error('Only one frequency value is required')
    elseif strcmp(type,'stop') || strcmp(type,'bandpass') 
        if numel(freq) == 1 || numel(freq) > 2
        error('Two frequency values are required')
        elseif numel(freq) == 2
            freq = [min(freq) max(freq)];
        end
    end
    
    if ~isa(NF, 'double')
        NF = double(NF);
    end
    
    [b,a] = butter (order,2.*freq/srate,type) ;
    l = size(NF);
    [~,dim] = min(l);
    F = NaN(size(NF));
    for c = 1:1:size(NF,dim)
        if dim == 1
            F(c,:) = filtfilt(b,a,NF(c,:));
        elseif dim == 2
            F(:,c) = filtfilt(b,a,NF(:,c));
        else
            error('Two-dimensional data required')
        end
    end
end
