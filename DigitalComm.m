clc; clear vars; close all;

[s_t,Fs] = audioread('message_signal.mp3');
s_t = mean(s_t, 2);



[d_mod, delta,k] = delta_mod(s_t, Fs);



figure;

plot(s_t, 'b')

v_t = 3.33*delta_demod(d_mod, delta,k);



figure;

plot(v_t', 'g')

audiowrite('recovered_signal.mp3',v_t,Fs);