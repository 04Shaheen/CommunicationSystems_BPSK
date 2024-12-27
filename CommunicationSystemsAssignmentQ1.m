clc
close all
clear all

f = 1000;             
time = 0.01;%time duration          
fs = 2*f;%sampling freqeuncy           
t = 0:0.00001:time;

x = sin(2*pi*f*t);


Ts = 1/fs;                   
pulse_train = zeros(size(t));%pulse train for sampling
sampling_points = 1:round(Ts/0.00001):length(t);
pulse_train(sampling_points) = 1;%point of the pulse train corresponding to sampling frequency set as 1

%multiplying with pulse train for sampling
sampled_signal = x .* pulse_train;

sample_times = t(sampling_points);     
sample_values = sampled_signal(sampling_points);  
reconstructed_signal = zeros(size(t));

%placing sinc function at every sampled instant and adding together to
%reconstruct signal, practical reconstruction was not specified.
for i = 1:length(sample_times)
    reconstructed_signal = reconstructed_signal + sample_values(i) * sinc((t - sample_times(i)) / Ts);
end

N = length(t);            % Number of points for FFT
f_axis = (0:N-1) * (1/(N * 0.00001));  % Frequency axis for plotting
X = fft(x, N);
X_mag = abs(X) / N;


S = fft(sampled_signal, N);
S_mag = abs(S) / N;
R = fft(reconstructed_signal, N);
R_mag = abs(R) / N;

%original, sampled, reconstructed signal
figure;

subplot(3,1,1)
plot(t, x)
title('Original Signal')
ax = gca;
ax.XAxisLocation = 'origin';
grid on

subplot(3,1,2)
stem(t, sampled_signal)
title('Sampled Signal')
ax = gca;
ax.XAxisLocation = 'origin';
grid on

subplot(3,1,3)
plot(t, reconstructed_signal)
title('Reconstructed Signal')
ax = gca;
ax.XAxisLocation = 'origin';
grid on

%fourier transforms figures
figure;

subplot(3,1,1)
plot(f_axis(1:N/2), X_mag(1:N/2))
title('Fourier Transform of Original Signal')
xlabel('Frequency (Hz)')
ylabel('Magnitude')
grid on

subplot(3,1,2)
plot(f_axis(1:N/2), S_mag(1:N/2))
title('Fourier Transform of Sampled Signal')
xlabel('Frequency (Hz)')
ylabel('Magnitude')
grid on

subplot(3,1,3)
plot(f_axis(1:N/2), R_mag(1:N/2))
title('Fourier Transform of Reconstructed Signal')
xlabel('Frequency (Hz)')
ylabel('Magnitude')
grid on


