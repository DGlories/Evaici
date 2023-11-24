% function [t,S1,S2,freq,WPS_S1,WPS_S2,WCPS,WPD,SRoWCS,WMSC,WMSCwSWCPS] = TFCA_Calculate(s1,s2,srate,nvoice,J1,wavenumber,warnfig)
% -------------------------------------------------------------------------
% TFCA_Calculate, last modified 11-01-2019
% CALCULATION of time-frequency wavelet-based coherence
% -----
% David AMARANTINI, PhD    <(-_-)>
%	david.amarantini@inserm.fr / david.amarantini@univ-tlse3.fr
%	Paul Sabatier University (UPS)
%	TOulouse NeuroImaging Center (ToNIC, UMR 1214 Inserm / UPS)
% -----
% Requires:
% - WaveCrossSpec software: http://www.math.u-bordeaux1.fr/~jbigot/Site/Software_files/WavCrossSpec.zip
% - Extract substring (substr.m): https://www.mathworks.com/matlabcentral/fileexchange/25064-extract-substring
% - REVERSE reverses the order of elements in a one-dimensional MATLAB ARRAY (reverse.m): http://atcollab.sourceforge.net/m2html/lattice/reverse.html
% -------------------------------------------------------------------------
% Syntax:
% [t,S1,S2,freq,WPS_S1,WPS_S2,WCPS,WPD,SRoWCS,WMSC,WMSCwSWCPS] = TFCA_Calculate(s1,s2,srate,nvoice,J1,wavenumber,warnfig) ;
% -----
% Required input argument list:
% - s1: N repetitions x n observations matrix of pre-processed (bandpass filtered, centered) first signal
% - s2: N repetitions x n observations matrix of pre-processed (bandpass filtered, centered) second signal
% - srate: Sampling frequency
% - nvoice: A higher # will give better scale resolution, but be slower to plot
% - J1: The # of scales minus one. Scales range from S0 up to S0*2^(J1*DJ), to give a total of (J1+1) scales
% - wavenumber: The mother wavelet parameter ; for 'MORLET' this is k0 (wavenumber)
% - warnfig: If 1, display a warning dialog until the user has clicked a mouse button or pressed a key
% -----
% Output argument list:
% - t: Time vector (s)
% - S1: 1st mean centered signal
% - S2: 2nd mean centered signal
% - freq: Frequency vector (Hz)
% - WPS_S1: Time-frequency wavelet-based power spectrum of signal S1
% - WPS_S2: Time-frequency wavelet-based power spectrum of signal S2
% - WCPS: Time-frequency wavelet-based cross power spectrum between S1 and S2
% - WPD: Time-frequency wavelet-based phase difference
% - SRoWCS: Significant areas of correlation between S1 and S2 in the time-frequency plane
% - WMSC: Time-frequency wavelet-based magnitude-squared coherence between S1 and S2
% - WMSC: Time-frequency wavelet-based magnitude-squared coherence between S1 and S2 on significant areas of correlation in the time-frequency plane
% -------------------------------------------------------------------------