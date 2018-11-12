% generate signal
fs = 300; % sampling frequency
f = 5;     % signal frequency
t = 5;      % time duration
n = [1:1/fs:t]; % sample vector

x = 3*sin(2*pi*f*n); % single tone signal

[x_dim, y_dimen] = size(x);
z=zeros([x_dim, y_dimen]);

for i=1:y_dimen
    z(:,i) = x(:,i)+randn(); 
end
z;  % noisy signal

figure(1)
subplot(2,1,1); plot(n,x); title('Sinusoidal signal');
subplot(2,1,2); plot(n,z); title('signal with noise');

% IIR Butterworth LPF filter Design
order = 100;  % order of the filter
Wc = 2*pi*f/fs;     % normalized cut-off frequency (as of signal freq)

[b,a] = butter(order,Wc,'low'); % Nr and Dr coeff. of IIR butterworth filter

fvtool(b,a); % filter frequency response

% filter the signal
x_f_iir = filter(b,a,z);

figure(2); plot(n,x_f_iir); title('Filtered Sinusoidal Signal');

% FIR Filter Design
order = 1024;
b = fir1(order,Wc); % FIR low pass filter

figure(3);freqz(b,1,512); % frequency response of FIR LPF filter

% filter the signal
tic
x_f_fir = filter(b,1,z);
time = toc
figure(4); plot(n,x_f_fir); title('Filtered Sinusoidal Signal');
