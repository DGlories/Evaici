% -------------------------------------------------------------------------
% TFCA_Example, last modified 08-01-2019
% Full time-frequency wavelet-based coherence scripting example
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
% - Jet Variant (jetvar.m): http://www.mathworks.com/matlabcentral/fileexchange/34803-jet-variant
% - freezeColors / unfreezeColors (freezecolors.m): http://www.mathworks.com/matlabcentral/fileexchange/7943-freezecolors---unfreezecolors
% - COLORMAP and COLORBAR utilities (cbfreeze.m) : http://www.mathworks.com/matlabcentral/fileexchange/24371-colormap-and-colorbar-utilities--jul-2014-
% -----
% References:
% - Bigot J. et al. (2011). Neuroimage, 55(4):1504-18. doi: 10.1016/j.neuroimage.2011.01.033.
% - Blais M. et al. (2018). Dev Sci., 21(3):e12563. doi: 10.1111/desc.12563.
% - Charissou C. et al. (2016). J Electromyogr Kinesiol., 27:52-9. doi: 10.1016/j.jelekin.2016.02.002.
% - Charissou C. et al. (2017). Eur J Appl Physiol., 117(11):2309-2320. doi: 10.1007/s00421-017-3718-6.
% - Cremoux S. et al. (2017). Eur J Neurosci., 46(4):1991-2000. doi: 10.1111/ejn.13641.
% - Cremoux S. et al. (2018). Clin Neurophysiol., 129(Suppl. 1): e33. doi: 10.1016/j.clinph.2018.04.081.
% - Dal Maso F. et al. (2017). Exp Brain Res., 235(10):3023-3031. doi: 10.1007/s00221-017-5035-z.
% -------------------------------------------------------------------------

tic ; % Start stopwatch timer
% -----
% Load EMG-EMG datasample
load('TFCA_Example_datasample_EMGEMG.mat') ;
% -----
% Additional inputs
woi_bnds =[3 7] ; % Lower and upper bounds of the time window of interest in second (s)
f_bnds = [15 30] ; % Lower and upper bounds of the frequency band of interest in Hertz (Hz)
nvoice = 7 ; % A higher # will give better scale resolution, but be slower to plot
J1 = 50 ; % The # of scales minus one. Scales range from S0 up to S0*2^(J1*DJ), to give a total of (J1+1) scales
wavenumber = 10 ; % The mother wavelet parameter ; for 'MORLET' this is k0 (wavenumber)
% -----
% Calculate time-frequency wavelet-based coherence
doc TFCA_help_Calculate ;
[t,S1,S2,freq,WPS_S1,WPS_S2,WCPS,WPD,SRoWCS,WMSC,WMSCwSWCPS] = TFCA_Calculate(s1,s2,srate,nvoice,J1,wavenumber,1) ;
% -----
% Quantify time-frequency wavelet-based magnitude-squared coherence
doc TFCA_help_Quantify ;
[N,SURFACE,MEANincl0,MEANexcl0,VOLUME] = TFCA_Quantify(srate,freq,SRoWCS,WMSC,woi_bnds,f_bnds) ;
% -----
% Display an illustrative figure of the differents steps used for wavelet coherence analysis
doc TFCA_help_Display ;
TFCA_Display(t,S1,'EMG VM','V',S2,'EMG VL','V',freq,WPS_S1,WPS_S2,WCPS,SRoWCS,WMSC,woi_bnds,f_bnds,0,12) ;
% -----
elapsedTime = toc ; %Read elapsed time from stopwatch
fprintf(1,'=> Full TFCA took %f seconds to run <(-_-)>\n', elapsedTime) ;

% -------------------------------------------------------------------------
