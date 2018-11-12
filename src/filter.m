clear; clc; close all;
% generate signal
fs = 300; % sampling frequency
f = 5;     % signal frequency
t = 5;      % time duration
n = [1:1/fs:t]; % sample vector
x = 3*sin(2*pi*f*n); % single tone signal

seed = 1;
rng(seed);

z = x + randn(size(x));

figure(1)
subplot(2,1,1); plot(n,x); title('Sinusoidal signal');
subplot(2,1,2); plot(n,z); title('signal with noise');


% % IIR Butterworth LPF filter Design
% order = 100;  % order of the filter
 Wc = 0.05;%2*pi*f/fs;     % normalized cut-off frequency (as of signal freq)
% [b,a] = butter(order,Wc,'low'); % Nr and Dr coeff. of IIR butterworth filter
% fvtool(b,a); % filter frequency response
% % filter the signal
% x_f_iir = filter(b,a,z);
% figure(2); plot(n,x_f_iir); title('Filtered Sinusoidal Signal');


% FIR Filter Design
order = 64;
b1= fir1(order, Wc);
bls = firls(order, [0 Wc 0.14 1], [1 1 0 0]); % FIR low pass filter
bpm = firpm(order, [0 Wc 0.14 1], [1 1 0 0]); % FIR low pass filter
figure(3);freqz(b1,1,512); % frequency response of FIR LPF filter
hold on;
freqz(bls,1,512); % frequency response of FIR LPF filter
freqz(bpm,1,512); % frequency response of FIR LPF filter

% filter the signal
x_f_fir = filter(bls,1,z);
final = x_f_fir(order/2:end);
figure(4);plot(z, '--');hold on; plot(final); title('Filtered Sinusoidal Signal');

