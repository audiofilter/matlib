% Communications Toolbox.
% Version 2.0  17-Aug-93
% Copyright (c) 1991-93 by Ryerson Polytechnic University
%
% RANDOM NUMBER GENERATION 
%    binary ............ random binary digits 
%    corr_seq .......... first order auto-regressive process 
%    exponent .......... exponential random variate 
%    gauss ............. Gaussian random variate 
%    laplace ........... Laplace random variate 
%    uniform ........... uniform random variate 
%    realize ........... sinusoidal random process with random phase 
%    speech ............ random voiced speech signal 
% 
% PROBABILISTIC ANALYSIS 
%    cdf ............... sample cdf of a random sequence. 
%    exp_cdf ........... cdf of an exponential random variable 
%    exp_pdf ........... pdf of an exponential random variable 
%    gamma_pdf ......... pdf of a gamma random variable  
%    gaus_cdf .......... cdf of a Gaussian random variable 
%    gaus_pdf .......... pdf of a Gaussian random variable 
%    lapl_cdf .......... cdf of a Laplacian random variable 
%    lapl_pdf .......... pdf of a Laplacian random variable 
%    meansq ............ mean-square power 
%    pdf ............... sample pdf of a random sequence 
%    q_function ........ Q function 
%    rayl_cdf .......... cdf of a Rayleigh random variable 
%    rayl_pdf .......... pdf of a Rayleigh random variable 
%    unif_cdf .......... cdf of a uniform random variable 
%    unif_pdf .......... pdf of a uniform random variable 
%    var ............... variance 
% 
% PROBABILITY & RANDOM PROCESS GAMES 
%    dice .............. random experiment with a die 
%    dart .............. visual depiction of a dart game 
%    guess ............. guess personal information data 
%    integral .......... integration of a function by Monte-Carlo simulation
%    new_born .......... sample function representing new born babies 
%    person_data ....... generation of personal records   
%    temperature ....... sample function representing day time temperature 
% 
% GENERAL PURPOSE ANALYSIS TOOLS 
%    acf ............... autocorrelation function 
%    acf_plot .......... autocorrelation function display 
%    ecorr ............. ensemble autocorrelation function 
%    psd ............... power spectral density function 
%    psd_plot .......... power spectral density function display 
% 
% QUANTIZATION 
%    a2d ............... analog-to-digital conversion 
%    d2a ............... digital-to-analog conversion 
%    mu_inv ............ mu-law expansion 
%    mu_law ............ mu-law companding 
%    quant_ch .......... quantizer characteristics 
%    quant_ef .......... quantizer efficiency 
%    quantize .......... uniform quantization 
% 
% BINARY DATA PROCESSING 
%    bcd ............... binary-coded-decimal coding 
%    bin_enc ........... natural binary source coding 
%    bin_dec ........... natural binary source decoding 
%    bin2gray .......... natural binary to gray-code conversion 
%    gray2bin .......... gray-code to natural binary conversion 
%    bin2pol ........... binary to polar transformation 
%    bin2bipo .......... binary to bipolar transformation 
%    diff_dec .......... differential decoding 
%    diff_enc .......... differential encoding 
%    invert ............ 1's complement of a binary sequence 
%    par2ser ........... parallel-to-serial conversion 
%    pol2bin ........... polar to binary transformation 
%    ser2par ........... serial-to-parallel conversion 
%    xor ............... exclusive OR 
% 
% BINARY SIGNALLING FORMATS 
%    manchest .......... Manchester pulse 
%    rect_nrz .......... rectangular NRZ pulse 
%    rect_rz ........... rectangular RZ pulse 
%    triangle .......... triangular pulse 
%    nyquist ........... Nyquist pulse 
%    nyq_gen ........... generate Nyquist waveform 
%    duob_gen .......... generate duobinary waveform 
%    duobinar .......... modified duobinary pulse 
%    modulate .......... digital modulated wave (ASK,BPSK,FSK) 
%    osc ............... sinusoidal oscillator 
%    vco ............... voltage controlled oscillator 
%    wave_gen .......... binary signal waveform generation 
%    waveplot .......... display binary signal waveform 
% 
% DATA TRANSMISSION 
%    bpf ............... band-pass filter 
%    channel ........... data communication channel 
%    eye_diag .......... eye diagram generation and display 
%    lpf ............... low-pass filter 
%    rc ................ 1-st order RC-filter 
%    detect ............ binary data detection 
%    envelope .......... envelope detector 
%    int_dump .......... integrate-and-dump filter 
%    mixer ............. two input mixer 
%    match ............. matched filter 
%    rx ................ receiver function 
%    tx ................ transmitter function 
% 
% UTILITY FUNCTIONS 
%    blackbox .......... filter with unknown order and bandwidth    
%    check ............. check initialization of global variables
%    exp5_c6 ........... compute signal power and SQNR 
%    fftsize ........... determine FFT size 
%    fx_menu ........... sample functions to be integrated 
%    limiter ........... limit input sequence to a user specified range 
%    mc_int ............ basic integration function used by integral
%    normalize ......... scale input sequence 
%    play .............. play-back a MATLAB array (MEX-file)
%    playback .......... play-back a pre-processed sound file 
%    record ............ record and convert into a MATLAB array (MEX-file)
%    rectify ........... rectify input sequence 
%    sinc .............. sin({pi}x)/({pi}x)
%    spec_est .......... spectral estimation 
%    start ............. initialize global variables
%    stat_plot ......... scatter diagram display 

% MODIFIED Matlab FUNCTIONS (you do not have to worry about these)
%    chhoices .......... derived from "choices"
%    polar1 ............ derived from "polar"
%    stair ............. modified version of the MATLAB function "stairs"
