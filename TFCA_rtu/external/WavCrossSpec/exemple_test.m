%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This file provides an example of the use of the "WavCrossSpec" Matlab
% codes which can be downloaded at the URL :
% http://www.math.univ-toulouse.fr/~bigot/
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% These codes have been used to produce some of the Figures of the paper :
%
% Bigot, J., Longcamp, M., Dal Maso, F. & Amarantini, D. (2011) 
% A new statistical test based on the wavelet cross-spectrum to detect
% time-frequency dependence between non-stationary signals:
% application to the analysis of cortico-muscular interactions,
% NeuroImage, 55(4):1504-18.

% This Matlab code is based on the use the MATLAB package provided by
% Aslak Grinsted, John Moore and Svetlana Jevrejeva for performing 
% cross-wavelet and wavelet coherence analysis which can be downloaded at: 
% http://www.pol.ac.uk/home/research/waveletcoherence/ 

% To simpliy the use of this toolbox we have also included in the .zip
% file WavCrossSpec.zip a copy of the MATLAB package provided by
% A. Grinsted et al. that is contained in the directory wtc-r16/

% Copyright (c) 2011
%
% Institut de Mathématiques de Toulouse UMR 5219
% Université Paul-Sabatier (Toulouse III)
% 31062 Toulouse, Cedex 9
%
% mailto: Jeremie.Bigot@math.univ-toulouse.fr

% Prepends the files in the directory WavCrossSpec to the current
% matlabpath.

localpath = '/Volumes/jbigot/Travail_iDisk/Programmation/Coherence_final/';
% Note that it is a local directory which must be modified !!
addpath([localpath 'WavCrossSpec'])
addpath([localpath 'WavCrossSpec/wtc-r16']) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code to reproduce the Figures correspondong to the simulated data of
% Example 1 in the above cited paper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;

% Create two signals s1 and s2 whose time/frequency coherence is known 

% Number of trials
N = 20;

% Sampling rate
rate = 1000;

% Number of observations for each trial
n = 1000;
T = n/rate;

t = linspace(0,1,n/T);
t1 = 0.3; t2 = 0.7;
w1 = 2*pi*10; w2 = 2*pi*30;
a1 = 1.2; a2 = 1.5;
f1init = sin(w1*t).*(t < t1) + sin(w2*t).*((t >= t1)&(t < t2));
f2init = a1*sin(w1*t).*(t < t1) + a2*sin(w2*t).*((t >= t1)&(t < t2));
f1 = [];
f2 = [];

for (k = 1:T)
    f1 = [f1 f1init];
    f2 = [f2 f2init];
end

SNR = -5;
sigmaX = exp(-log(10)*SNR/20)*max(abs(f1));
sigmaY = exp(-log(10)*SNR/20)*max(abs(f2));

s1 = zeros(N,n);
s2 = zeros(N,n);

for (i = 1:N)
    X = randn(1,1);
    s1(i,:) = X*f1 + sigmaX*randn(1,n);
    s2(i,:) = X*f2 + sigmaY*randn(1,n);
end

t = linspace(0,1000,n);

figure(1)
subplot(2,1,1)
plot(t,s1(2,:),'LineWidth',1)
text(n/2-25,-15,'ms');
subplot(2,1,2)
plot(t,s2(2,:),'r','LineWidth',1)
text(n/2-25,-15,'ms');

% Empirical covariance matrices of the data and computation of their
% largest eigenvalues
beta = 1;
indice = 1:n;
X1 = zeros(N,length(indice));
X2 = zeros(N,length(indice));
for (i = 1:N)
   X1(i,:) = s1(i,indice);
   X2(i,:) = s2(i,indice);
end

W1 = transpose(X1)*X1/N;
W2 = transpose(X2)*X2/N;

e1 = eig(W1);
e2 = eig(W2);

eps1 = sqrt(max(e1)/((1+sqrt(length(indice)/N)+sqrt(-2*log(beta)/N))^2));
eps2 = sqrt(max(e2)/((1+sqrt(length(indice)/N)+sqrt(-2*log(beta)/N))^2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use Morlet wavelets
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dt = 1/n;
nvoice = 5;

%----------default arguments for the wavelet transform-----------
Args=struct('Pad',1,...      % pad the time series with zeroes (recommended)
            'Dj',nvoice, ...    % this will do nvoice sub-octaves per octave
            'S0',1,...    % this says start at a scale of 2 years
            'J1',[],...
            'Mother','Morlet',...
            'MaxScale',[],...
            'Cycles',-1);
           %'S0',2*(1/n),...    % this says start at a scale of 2 years

if isempty(Args.J1)
    if isempty(Args.MaxScale)
        Args.MaxScale=(n*.17)*2*(dt); %automaxscale
    end
    % Args.J1=round(log2(Args.MaxScale/Args.S0)/Args.Dj);
    Args.J1=50;
end

[wavetrue1,period,scale,coi] = wavelet(f1',dt,Args.Pad,Args.Dj,Args.S0,Args.J1,Args.Mother,Args.Cycles);
[wavetrue2,period,scale,coi] = wavelet(f2',dt,Args.Pad,Args.Dj,Args.S0,Args.J1,Args.Mother,Args.Cycles);

for (i = 1:N)
    [wave1{i},period,scale,coi] = wavelet(s1(i,:)',dt,Args.Pad,Args.Dj,Args.S0,Args.J1,Args.Mother,Args.Cycles);
    [wave2{i},period,scale,coi] = wavelet(s2(i,:)',dt,Args.Pad,Args.Dj,Args.S0,Args.J1,Args.Mother,Args.Cycles);
end

freq = 1./period;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Computation of theCros_Spectrum and Cross_Coherence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Empirical time-frequencey maps with N trials
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[nb_scale n] = size(wave1{1});
cross_spectrum = zeros(nb_scale,n);
cross_coherence = zeros(nb_scale,n);
norm2_X = zeros(nb_scale,n);
norm2_Y = zeros(nb_scale,n);

for (i=1:N)
    norm2_X = norm2_X+abs(wave1{i}).^2;
    norm2_Y = norm2_Y+abs(wave2{i}).^2;
end

norm2_X = norm2_X/N;
norm2_Y = norm2_Y/N;

for (i=1:N)
    cross_spectrum = cross_spectrum + (wave1{i}).*conj(wave2{i});
end
cross_spectrum = abs(cross_spectrum/N).^2;
cross_coherence = cross_spectrum./(norm2_X.*norm2_Y);

figure(1)
clf
image((norm2_X/max(max(norm2_X)))*255);
axis xy
axis off
text(0,-5,'0'); text(n-30,-5,'1000'); text(n/2-25,-5,'500'); text(n/4-25,-5,'250'); text(3*n/4-25,-5,'750')
text(n/2-25,-20,'ms');
nb_indice = 5;
indice = [40 93 145 198];
text(-45,nb_scale,'0');
text(-90,nb_scale/2,'Hz');
for (j = 1:length(indice))
    text(-45,indice(j),num2str(floor(freq(indice(j))/T)));
end
title('Empirical auto-sprectrum of s1 with N trials')

figure(2)
image((norm2_Y/max(max(norm2_Y)))*255);
axis xy
axis off
text(0,-5,'0'); text(n-30,-5,'1000'); text(n/2-25,-5,'500'); text(n/4-25,-5,'250'); text(3*n/4-25,-5,'750')
text(n/2-25,-20,'ms');
nb_indice = 5;
indice = [40 93 145 198];
text(-45,nb_scale,'0');
text(-90,nb_scale/2,'Hz');
for (j = 1:length(indice))
    text(-45,indice(j),num2str(floor(freq(indice(j))/T)));
end
title('Empirical auto-sprectrum of s2 with N trials')


figure(3)
image((cross_spectrum/max(max(cross_spectrum)))*255);
axis xy
axis off
text(0,-5,'0'); text(n-30,-5,'1000'); text(n/2-25,-5,'500'); text(n/4-25,-5,'250'); text(3*n/4-25,-5,'750')
text(n/2-25,-20,'ms');
nb_indice = 5;
indice = [40 93 145 198];
text(-45,nb_scale,'0');
text(-90,nb_scale/2,'Hz');
for (j = 1:length(indice))
    text(-45,indice(j),num2str(floor(freq(indice(j))/T)));
end
title('Cross sprectrum with N trials')


figure(4)
image((cross_coherence/max(max(cross_coherence)))*255);
axis xy
axis off
text(0,-5,'0'); text(n-30,-5,'1000'); text(n/2-25,-5,'500'); text(n/4-25,-5,'250'); text(3*n/4-25,-5,'750')
text(n/2-25,-20,'ms');
nb_indice = 5;
indice = [40 93 145 198];
text(-45,nb_scale,'0');
text(-90,nb_scale/2,'Hz');
for (j = 1:length(indice))
    text(-45,indice(j),num2str(floor(freq(indice(j))/T)));
end
title('Cross coherence with N trials')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time-frequencey maps with an infinite number of trials
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cross_spectrum_true = zeros(nb_scale,n);
cross_coherence_true = zeros(nb_scale,n);
norm2_X_true = zeros(nb_scale,n);
norm2_Y_true = zeros(nb_scale,n);

norm2_X_true = abs(wavetrue1).^2 + sigmaX^2;
norm2_Y_true = abs(wavetrue2).^2 + sigmaY^2;
cross_spectrum_true = abs(wavetrue1.*conj(wavetrue2)).^2 ;
cross_coherence_true = abs((wavetrue1.*conj(wavetrue2))./(sqrt(norm2_X_true.*norm2_Y_true))).^2;

figure(1)
clf
image((norm2_X_true/max(max(norm2_X_true)))*255);
axis xy
axis off
text(0,-5,'0'); text(n-30,-5,'1000'); text(n/2-25,-5,'500'); text(n/4-25,-5,'250'); text(3*n/4-25,-5,'750')
text(n/2-25,-20,'ms');
nb_indice = 5;
indice = [40 93 145 198];
text(-45,nb_scale,'0');
text(-90,nb_scale/2,'Hz');
for (j = 1:length(indice))
    text(-45,indice(j),num2str(floor(freq(indice(j))/T)));
end
title('Auto-sprectrum of s1 with an infinite number of trials')



figure(2)
image((norm2_Y_true/max(max(norm2_Y_true)))*255);
axis xy
axis off
text(0,-5,'0'); text(n-30,-5,'1000'); text(n/2-25,-5,'500'); text(n/4-25,-5,'250'); text(3*n/4-25,-5,'750')
text(n/2-25,-20,'ms');
nb_indice = 5;
indice = [40 93 145 198];
text(-45,nb_scale,'0');
text(-90,nb_scale/2,'Hz');
for (j = 1:length(indice))
    text(-45,indice(j),num2str(floor(freq(indice(j))/T)));
end
title('Auto-sprectrum of s2 with an infinite number of trials')

figure(5)
image((cross_spectrum_true/max(max(cross_spectrum_true)))*255);
axis xy
axis off
text(0,-5,'0'); text(n-30,-5,'1000'); text(n/2-25,-5,'500'); text(n/4-25,-5,'250'); text(3*n/4-25,-5,'750')
text(n/2-25,-20,'ms');
nb_indice = 5;
indice = [40 93 145 198];
text(-45,nb_scale,'0');
text(-90,nb_scale/2,'Hz');
for (j = 1:length(indice))
    text(-45,indice(j),num2str(floor(freq(indice(j))/T)));
end
title('Cross spectrum with an infinite number of trials')

figure(6)
image((cross_coherence_true/max(max(cross_coherence_true)))*255);
axis xy
axis off
text(0,-5,'0'); text(n-30,-5,'1000'); text(n/2-25,-5,'500'); text(n/4-25,-5,'250'); text(3*n/4-25,-5,'750')
text(n/2-25,-20,'ms');
nb_indice = 5;
indice = [40 93 145 198];
text(-45,nb_scale,'0');
text(-90,nb_scale/2,'Hz');
for (j = 1:length(indice))
    text(-45,indice(j),num2str(floor(freq(indice(j))/T)));
end
title('Cross coherence with an infinite number of trials')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test of significativity of the cross-spectrum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

detect_cross_spectrum = zeros(nb_scale,n);

% Level of each individual test
alpha = 0.05;
thr = eps1*eps2*(-log(alpha/2)/N+sqrt(-2*log(alpha/2)/N));
for (s = 1:nb_scale)   
    detect_cross_spectrum(s,:) = cross_spectrum(s,:) > thr^2;
end

% Signficant region of the cross-spectrum
figure(7)
image(detect_cross_spectrum*255)
axis xy
axis off
text(0,-5,'0'); text(n-30,-5,'1000'); text(n/2-25,-5,'500'); text(n/4-25,-5,'250'); text(3*n/4-25,-5,'750')
text(n/2-25,-20,'ms');
nb_indice = 5;
indice = [40 93 145 198];
text(-45,nb_scale,'0');
text(-90,nb_scale/2,'Hz');
for (j = 1:length(indice))
    text(-45,indice(j),num2str(floor(freq(indice(j))/T)));
end
title('Significativity of the cross spectrum at level alpha')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test of significativity of the coherence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

detect_cross_coherence = zeros(nb_scale,n);
alpha = 0.05;

thr = 1-alpha^(1/(N-1));
for (s = 1:nb_scale)   
    detect_cross_coherence(s,:) = cross_coherence(s,:) > thr;
end

figure(8)
image(detect_cross_coherence*255)
axis xy
axis off
text(0,-5,'0'); text(n-30,-5,'1000'); text(n/2-25,-5,'500'); text(n/4-25,-5,'250'); text(3*n/4-25,-5,'750')
text(n/2-25,-20,'ms');
nb_indice = 5;
indice = [40 93 145 198];
text(-45,nb_scale,'0');
text(-90,nb_scale/2,'Hz');
for (j = 1:length(indice))
    text(-45,indice(j),num2str(floor(freq(indice(j))/T)));
end
title('Significativity of the coherence at level alpha')


