function [bit_array, delta_1,k] = delta_mod(message_signal, Fs)

    N = length(message_signal);
    bit_array = zeros(1, N);
    
    %% Step size calculation
    delta = (1/Fs) * max(diff(message_signal))*1.2e3;
    delta_1 = delta;
    delta_prev = delta;
    k_inc= 1.5; %adaptation factor
    k_dec =0.5;
    %% Modulation
    v_t = zeros(1, N);
    v_t(1) = 0;
    e_t = 0;
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

            if e_t == e_t_prev
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
k = [k_inc k_dec];
end

