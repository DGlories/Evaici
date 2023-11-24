% function [N,SURFACE,MEANincl0,MEANexcl0,VOLUME] = TFCA_Quantify(srate,freq,SRoWCS,WMSC,woi_bnds,f_bnds)
% -------------------------------------------------------------------------
% TFCA_Quantify, last modified 27-12-2018
% QUANTIFICATION of time-frequency wavelet-based magnitude-squared coherence
% -----
% David AMARANTINI, PhD    <(-_-)>
%	david.amarantini@inserm.fr / david.amarantini@univ-tlse3.fr
%	Paul Sabatier University (UPS)
%	TOulouse NeuroImaging Center (ToNIC, UMR 1214 Inserm / UPS)
% -------------------------------------------------------------------------
% Syntax:
% [N,SURFACE,MEANincl0,MEANexcl0,VOLUME] = TFCA_Quantify(srate,freq,SRoWCS,WMSC,woi_bnds,f_bnds) ;
% -----
% Required input argument list:
% - srate: Sampling frequency
% - freq: Frequency vector (Hz)
% - SRoWCS: Significant areas of correlation in the time-frequency plane
% - WMSC: Time-frequency wavelet-based magnitude-squared coherence
% -----
% Optional input argument list:
% - woi_bnds (2x1 matrix): Lower and upper bounds of the time window of interest in second (s)
% - f_bnds (2x1 matrix): Lower and upper bounds of the frequency band of interest in Hertz (Hz)
% -----
% Output argument list:
% - N: Number of time-frequency points where correlation is significant in the time-frequency plane
% - SURFACE: Surface of the areas where correlation is significant in the time-frequency plane
% - MEANincl0: Mean including 0 of magnitude-squared coherence values where correlation is significant inside the limits of interest
% - MEANexcl0: Mean excluding 0 of magnitude-squared coherence values where correlation is significant inside the limits of interest
% - VOLUME: Volume under magnitude-squared coherence values where correlation is significant inside the limits of interest
% -------------------------------------------------------------------------