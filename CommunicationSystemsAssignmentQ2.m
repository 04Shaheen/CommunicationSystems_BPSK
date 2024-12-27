clc
close all
clear all

fs = 1e6;             
fc = 1e5;            
Tb = 1e-3;           
N = 16;             
snr_dB = -5;

data = randi([0 1], 1, N);
t = 0:1/fs:Tb-(1/fs);         
carrier = cos(2 * pi * fc * t);

bpsk_data = 2 * data - 1; 

% Expand each bit to match the carrier length for modulation
bpsk_signal = kron(bpsk_data, carrier); % Kronecker product for bit expansion

%noise
bpsk_signal_noisy = awgn(bpsk_signal, snr_dB, 'measured');

%multiply carrier to convert to baseband
demodulated_signal = bpsk_signal_noisy .* kron(ones(1, N), carrier);

% Integrate each bit period by reshaping and summing
demodulated_sum = sum(reshape(demodulated_signal, length(t), N));

%hard decision
received_data = demodulated_sum > 0;

%error calculation
bit_errors = sum(received_data ~= data);
BER = bit_errors / N;

% Display results
disp('Original Data (First 16 bits):');
disp(data(1:16));
disp('Received Data after Demodulation (First 16 bits):');
disp(received_data(1:16));
disp(['Bit Error Rate (BER): ', num2str(BER)]);

% Plot Original Signal
figure;
subplot(4,1,1);
stem(data(1:16), 'filled'); % Plot only the first 16 bits for readability
title('Original Data (Binary Sequence)');
xlabel('Bit Index');
ylabel('Bit Value');
xlim([1 16]);

% Plot Modulated Signal (Zoomed in to show phase changes)
subplot(4,1,2);
time_vector = (0:length(bpsk_signal)-1)/fs;
plot(time_vector, bpsk_signal);
title('BPSK Modulated Signal (Zoomed In to Show Phase Changes)');
xlabel('Time (s)');
ylabel('Amplitude');
xlim([0, 3*Tb]);  % Zoom in to display only the first 5 bits

% Plot Noisy Signal
subplot(4,1,3);
plot(time_vector, bpsk_signal_noisy);
title(['BPSK Signal with AWGN (SNR = ', num2str(snr_dB), ' dB)']);
xlabel('Time (s)');
ylabel('Amplitude');
xlim([0, 3*Tb]);  % Zoom in to display only the first 5 bits

% Plot Demodulated Signal (Decision Variable)
subplot(4,1,4);
stem(received_data(1:16), 'filled'); % Plot only the first 16 bits for readability
title('Demodulated Data');
xlabel('Bit Index');
ylabel('Bit Value');
xlim([1 16]);
