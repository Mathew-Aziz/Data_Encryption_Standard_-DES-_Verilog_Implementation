module des_encry_decry (
    input  [63:0] in_plaintext,
    input  [63:0] key,
    input clk,rst,
    input plian_key_valid,
    output [63:0] out_plaintext,
    output plain_data_valid,
    output true_operation 
);

    wire cipher_data_valid;
    wire [63:0] ciphertext;
    des_encryption encryption (
    .plaintext(in_plaintext),.key(key),
    .clk(clk),.rst(rst),
    .plian_key_valid(plian_key_valid),.ciphertext(ciphertext),
    .cipher_data_valid(cipher_data_valid)
    );

    des_decryption decryption(
    .ciphertext(ciphertext),.key(key),
    .clk(clk),.rst(rst),
    .cipher_key_valid(cipher_data_valid),.plaintext(out_plaintext),
    .plain_data_valid(plain_data_valid)
    );

    assign true_operation = (in_plaintext == out_plaintext);
endmodule