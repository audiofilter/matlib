========================================================================

We have developed a "Communications Toolbox" based on the Matlab code for
classroom use.  It is used by students taking a 4th year communications
course where the emphasis is on digital coding of waveforms and on digital
data transmission systems.  The Matlab code that constitutes this toolbox
has been in use for over two years.  

There are close to 100 "M-files" that implement various functions.  Some
of them are quite simple and are based on existing Matlab M-files.  But 
a great many of them has been created from scratch.  We also prepared 
a lab manual (in TEX format) for the 7 simulations which the students 
perform as the lab component of this course.  The topics of these simulations
are:

	[1]. Probability Theory
	[2]. Random Processes
	[3]. Quantization
	[4]. Binary Signalling Formats
	[5]. Detection
	[6]. Digital Modulation
	[7]. Digital Communication

All these M-files are designed to work in synergy and communicate with each 
other through the use of some global variables.  It was the only solution we 
could think of to isolate the student from  some unnecessary intricacies of 
simulation.  These M-files can also be freely used with other Matlab M-files.

Earlier last year I have made this toolbox and the manual available at the 
anonymous ftp site "evans.ee.adfa.oz.au".  This summer I have upgraded the 
toolbox such that all the M-files are now fully functional under MATLAB 4.x.
There are two Mex files, "play.mex4" and "record.mex4", written by Phillip 
Musumeci (phillip@ee.adfa.oz.au).   While the MATLAB 4.x offers same 
functionality, I believe these Mex files speed up sound processing 
considerably.  The manual has also been slightly updated.  I am still working 
to get all the figures in postscript format.  Please continue using the old 
manual until I have the new manual ready.   Meanwhile if you urgently need 
a manual drop me an e-mail.

============================
CONTACT
============================
Dr. Mehmet Zeytinoglu
	Department of Electrical & Computer Engineering
	Ryerson Polytechnic University
	350 Victoria Street
	Toronto, Ontario M5B 2K3
	CANADA

	Phone:  (416) 979-5000 ext 6078
	Fax  :  (416) 979-5280
	EMail:  mzeytin@ee.ryerson.ca

Here is  a more detailed description of the M-files included in this 
distribution.

============================
COMMUNICATION SYSTEM TOOLBOX  
============================
  Listing of M-files
======================

 RANDOM NUMBER GENERATION 
    binary ............ random binary digits 
    corr_seq .......... first order auto-regressive process 
    exponent .......... exponential random variate 
    gauss ............. Gaussian random variate 
    laplace ........... Laplace random variate 
    uniform ........... uniform random variate 
    realize ........... sinusoidal random process with random phase 
    speech ............ random voiced speech signal 
 
 PROBABILISTIC ANALYSIS 
    cdf ............... sample cdf of a random sequence. 
    exp_cdf ........... cdf of an exponential random variable 
    exp_pdf ........... pdf of an exponential random variable 
    gamma_pdf ......... pdf of a gamma random variable  
    gaus_cdf .......... cdf of a Gaussian random variable 
    gaus_pdf .......... pdf of a Gaussian random variable 
    lapl_cdf .......... cdf of a Laplacian random variable 
    lapl_pdf .......... pdf of a Laplacian random variable 
    meansq ............ mean-square power 
    pdf ............... sample pdf of a random sequence 
    q_function ........ Q function 
    rayl_cdf .......... cdf of a Rayleigh random variable 
    rayl_pdf .......... pdf of a Rayleigh random variable 
    unif_cdf .......... cdf of a uniform random variable 
    unif_pdf .......... pdf of a uniform random variable 
    var ............... variance 
 
 PROBABILITY & RANDOM PROCESS GAMES 
    dice .............. random experiment with a die 
    dart .............. visual depiction of a dart game 
    guess ............. guess personal information data 
    integral .......... integration of a function by Monte-Carlo simulation
    new_born .......... sample function representing new born babies 
    person_data ....... generation of personal records   
    temperature ....... sample function representing day time temperature 
 
 GENERAL PURPOSE ANALYSIS TOOLS 
    acf ............... autocorrelation function 
    acf_plot .......... autocorrelation function display 
    ecorr ............. ensemble autocorrelation function 
    psd ............... power spectral density function 
    psd_plot .......... power spectral density function display 
 
 QUANTIZATION 
    a2d ............... analog-to-digital conversion 
    d2a ............... digital-to-analog conversion 
    mu_inv ............ mu-law expansion 
    mu_law ............ mu-law companding 
    quant_ch .......... quantizer characteristics 
    quant_ef .......... quantizer efficiency 
    quantize .......... uniform quantization 
 
 BINARY DATA PROCESSING 
    bcd ............... binary-coded-decimal coding 
    bin_enc ........... natural binary source coding 
    bin_dec ........... natural binary source decoding 
    bin2gray .......... natural binary to gray-code conversion 
    gray2bin .......... gray-code to natural binary conversion 
    bin2pol ........... binary to polar transformation 
    bin2bipo .......... binary to bipolar transformation 
    diff_dec .......... differential decoding 
    diff_enc .......... differential encoding 
    invert ............ 1's complement of a binary sequence 
    par2ser ........... parallel-to-serial conversion 
    pol2bin ........... polar to binary transformation 
    ser2par ........... serial-to-parallel conversion 
    xor ............... exclusive OR 
 
 BINARY SIGNALLING FORMATS 
    manchest .......... Manchester pulse 
    rect_nrz .......... rectangular NRZ pulse 
    rect_rz ........... rectangular RZ pulse 
    triangle .......... triangular pulse 
    nyquist ........... Nyquist pulse 
    nyq_gen ........... generate Nyquist waveform 
    duob_gen .......... generate duobinary waveform 
    duobinar .......... modified duobinary pulse 
    modulate .......... digital modulated wave (ASK,BPSK,FSK) 
    osc ............... sinusoidal oscillator 
    vco ............... voltage controlled oscillator 
    wave_gen .......... binary signal waveform generation 
    waveplot .......... display binary signal waveform 
 
 DATA TRANSMISSION 
    bpf ............... band-pass filter 
    channel ........... data communication channel 
    eye_diag .......... eye diagram generation and display 
    lpf ............... low-pass filter 
    rc ................ 1-st order RC-filter 
    detect ............ binary data detection 
    envelope .......... envelope detector 
    int_dump .......... integrate-and-dump filter 
    mixer ............. two input mixer 
    match ............. matched filter 
    rx ................ receiver function 
    tx ................ transmitter function 
 
 UTILITY FUNCTIONS 
    blackbox .......... filter with unknown order and bandwidth    
    check ............. check initialization of global variables
    exp5_c6 ........... compute signal power and SQNR 
    fftsize ........... determine FFT size 
    fx_menu ........... sample functions to be integrated 
    limiter ........... limit input sequence to a user specified range 
    mc_int ............ basic integration function used by integral
    normalize ......... scale input sequence 
    play .............. play-back a MATLAB array (MEX-file)
    playback .......... play-back a pre-processed sound file 
    record ............ record and convert into a MATLAB array (MEX-file)
    rectify ........... rectify input sequence 
    sinc .............. sin({pi}x)/({pi}x)
    spec_est .......... spectral estimation 
    start ............. initialize global variables
    stat_plot ......... scatter diagram display 

 MODIFIED Matlab FUNCTIONS 
    chhoices .......... derived from "choices"
    polar1 ............ derived from "polar"
    stair ............. modified version of the MATLAB function "stairs"

 MANUAL
   The manual is 100+ pages long with a detailed procedure for each
   simulation.  It is in plain TEX format.  Only the figures are
   not in postscript.  But, I am working on it.  Each "experiment"
   also includes some pre-lab questions related to the material of
   that particular simulation.  The students are required to work
   these pre-lab problems out, before sitting in front of the terminal.
   As you may expect "suppose" is the key word here.

