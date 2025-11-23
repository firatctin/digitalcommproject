clc; clear vars; close all;
%% Audio document import
[s_t,Fs] = audioread('message_signal.mp3');
% In order to flattening the s(t) stereo signal we can take the mean of R
% and L channels to convert into Mono.
s_t = mean(s_t, 2);


%% Delto modulation
[d_mod, delta,k] = delta_mod(s_t, Fs); % Modulation
v_t = 3.33*delta_demod(d_mod, delta,k); % Demodulation

%% Results
figure;

plot(s_t, 'b')

figure;

plot(v_t', 'g')

audiowrite('recovered_signal.mp3',v_t,Fs); % Save result recovered signal