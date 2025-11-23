function [bit_array, delta_1,k] = delta_mod(message_signal, Fs)
    %% Description
    % delta_mod function is used to apply ADM to any one dimension time
    % signal 
    %%% Inputs
    % message_signal: the source signal in time domain
    % Fs sampling frequency of the message signal

    %%% Outputs
    % bit_array: the source coding result bit array which contains the
    % incrementation and decrementation bits
    % delta_1: the initial stepsize calculated by function itself for the
    % demodulator
    % k: adaptation index 
    N = length(message_signal);
    bit_array = zeros(1, N);
    
    %% Step size calculation
    delta = (1/Fs) * max(diff(message_signal))*1.2e3;
    delta_1 = delta;
    delta_prev = delta;
    k_inc= 1.5; %adaptation factor for increment
    k_dec =0.5; %adaptation factor for decrement
    %% Modulation
    v_t = zeros(1, N); % quantized signal
    v_t(1) = 0;
    e_t = 0; %error signal which takes the value +- 1 which represents quantized
    % signal is bigger or smaller than message signal
    e_t_prev = 0;
    % İlk bit
    if message_signal(1) > v_t(1)
        bit_array(1) = 1;
        e_t = 1;
    else
        bit_array(1) = 0;
        e_t = -1;
    end

    % Diğer örnekler
    for i = 2:N
        e_t_prev = e_t;
        delta_prev = delta;
        if message_signal(i) > v_t(i-1)
            
            e_t = 1;

            if e_t == e_t_prev % adaptive delta 
                delta = delta*k_inc;
            else
                delta = delta*k_dec;
            end
            v_t(i) = v_t(i-1) + delta;
            bit_array(i) = 1;
            disp(delta)
            e_t_prev = e_t;
        else
            
            e_t = -1;
            if e_t == e_t_prev
                delta = delta*k_inc;
            else
                delta = delta*k_dec;
            end
            
            v_t(i) = v_t(i-1) - delta;
            bit_array(i) = 0;
            disp(delta)
            e_t_prev = e_t;
        end
    end
bit_array = bit_array';
k = [k_inc k_dec]; %for demodulator
end

