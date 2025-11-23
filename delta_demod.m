function v_t = delta_demod(bit_array, delta, k)
    v_t = zeros(1, length(bit_array));
    v_t(1) = 0;
    k_inc = k(1);
    k_dec = k(2);
    

    if bit_array(1) == 1
        e_t = 1;
    else
        e_t = -1;
    
    end
    for i = 2:length(bit_array)
        e_t_prev = e_t;
        
      if bit_array(i) == 1
          e_t = 1;
          v_t(i) = v_t(i-1) + delta;
      else
          e_t = -1;
          v_t(i) = v_t(i-1) - delta;
      end

      if e_t == e_t_prev
          delta = delta*k_inc;
      else
          delta = delta*k_dec;
      end
    end
         
    
    
end

