% function TFCA_Display(t,S1,S1_source,S1_unit,S2,S2_source,S2_unit,freq,WPS_S1,WPS_S2,WCPS,SRoWCS,WMSC,woi_bnds,f_bnds,opt_title,fontsize)
% -------------------------------------------------------------------------
% TFCA_Display, similar to TFCA_Figure version 2.0, last modified 9-01-2019
% DISPLAY of a nice illustrative figure of the differents steps used for time-frequency wavelet-based coherence analysis
% -----
% David AMARANTINI, PhD    <(-_-)>
%	david.amarantini@inserm.fr / david.amarantini@univ-tlse3.fr
%	Paul Sabatier University (UPS)
%	TOulouse NeuroImaging Center (ToNIC, UMR 1214 Inserm / UPS)
% -----
% Requires:
% - Jet Variant (jetvar.m): http://www.mathworks.com/matlabcentral/fileexchange/34803-jet-variant
% - freezeColors / unfreezeColors (freezecolors.m): http://www.mathworks.com/matlabcentral/fileexchange/7943-freezecolors---unfreezecolors
% - COLORMAP and COLORBAR utilities (cbfreeze.m) : http://www.mathworks.com/matlabcentral/fileexchange/24371-colormap-and-colorbar-utilities--jul-2014-
% -------------------------------------------------------------------------
% Syntax:
% TFCA_Display(t,S1,S1_source,S1_unit,S2,S2_source,S2_unit,freq,WPS_S1,WPS_S2,WCPS,SRoWCS,WMSC,woi_bnds,f_bnds,opt_title,fontsize) ;
% -----
% Required input argument list:
% - t: Time vector (s)
% - S1: 1st mean centered signal
% - S1_source (character string): S1 signal data type (EEG or EMG) and channel (electrode name)
% - S1_unit (character string): S1 signal data unit
% - S2: 2nd mean centered signal
% - S2_source (character string): S2 signal data type (EEG or EMG) and channel (electrode name)
% - S2_unit (character string): S2 signal data unit
% - freq: Frequency vector (Hz)
% - WPS_S1: Wavelet power spectrum of signal S1
% - WPS_S2: Wavelet power spectrum of signal S2
% - WCPS: Wavelet cross power spectrum between S1 and S2
% - SRoWCS: Significant areas of correlation between S1 and S2 in the time-frequency plane
% - WMSC: Wavelet magnitude-squared coherence between S1 and S2
% -----
% Optional input argument list:
% - woi_bnds (2x1 matrix): Lower and upper bounds (s) of the time window of interest
% - f_bnds (2x1 matrix): Lower and upper bounds (Hz) of the frequency band of interest
% - opt_title (0/1): If 1, asks for figure titles
% - fontsize: Fontsize for all text elements in the figure
% -------------------------------------------------------------------------