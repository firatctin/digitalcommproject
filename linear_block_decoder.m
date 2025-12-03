function decoded_bits = linear_block_decoder(encoded_bits, original_length)

    H = [1 0 1 1 1 0 0 0;
         1 1 1 0 0 1 0 0;
         0 1 1 1 0 0 1 0;
         1 1 0 1 0 0 0 1];

    H_T = H';
    
    rx_matrix = reshape(encoded_bits, 8, []).'; % Veri 8'li paketlere bölündü
    [num_blocks, ~] = size(rx_matrix); % Elimizdeki paket sayısı
    
    corrected_matrix = zeros(num_blocks, 8);
    
    % Her blok için Sendrom Kod 
    for i = 1:num_blocks
        r = rx_matrix(i, :);
        
        S = mod(r * H_T, 2); % Sendrom Hesaplama: S = r * H^T (mod 2)
        
        % Hata Kontrolü
        if sum(S) == 0
            corrected_matrix(i, :) = r;  % Sendrom 0 ise hata yok
        else
            error_pos = 0;
            for column = 1:8
                if isequal(S, H(:, column).') % H'nin sütunu ile S kıyaslandı
                    error_pos = column;
                    break;
                end
            end
            
            % Hatayı düzeltme, Bit ters çevrilir
            if error_pos > 0
                r(error_pos) = ~r(error_pos); % 0->1 veya 1->0
            end
            corrected_matrix(i, :) = r;
        end
    end
    
    decoded_msg_matrix = corrected_matrix(:, 1:4); % G = [I | P'], ilk 4 bit mesajdır
   
    decoded_bits = reshape(decoded_msg_matrix.', 1, []); %Mesaj tekrar seri hale getirildi
 
end