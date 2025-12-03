function encoded_bits = linear_block_encoder(input_bits)

    % Proje föyünde verilen H matrisi ([P | I])
    H = [1 0 1 1 1 0 0 0;
         1 1 1 0 0 1 0 0;
         0 1 1 1 0 0 1 0;
         1 1 0 1 0 0 0 1];
     
    [n_minus_k, n] = size(H); % n_minus_k = 4, n = 8
    k = n - n_minus_k;        % k = 4 Bilgi biti sayısı
    P = H(:, 1:k); 
    
    % Generator Matris: G = [I_k | P^T]
    I_k = eye(k); % Köşegenleri birim matris
    P_T = P'; % P Transpoz
    G = [I_k, P_T];

    num_bits = length(input_bits); % Gelen bit sayısı k'nın (4) katı olmalı. Değilse '0' eklenir.
    remainder = mod(num_bits, k);
    
    if remainder ~= 0
        padding_count = k - remainder;
        input_bits = [input_bits, zeros(1, padding_count)];
    end
    
    % Veri 4'lü paketlere bölündü (Her satır bir mesaj vektörü m)
    msg_matrix = reshape(input_bits, k, []).'; % reshape matrisi sütun sütun doldurur ancak biz satır satır dolduracağız
   
    code_matrix = mod(msg_matrix * G, 2); % Binary olduğu için mod2 toplanır
    
    encoded_bits = reshape(code_matrix.', 1, []); %Tek satır vektörüne dönüştürüldü
end