`timescale 1ns / 1ps

module des_testbench;

  // Clock and reset
  reg         clk;
  reg         rst;

  // Encryption inputs and outputs
  reg  [63:0] plaintext;
  reg  [63:0] encryption_key;
  reg         encryption_valid;
  wire [63:0] ciphertext;
  wire        cipher_data_valid;

  // Held copy of the ciphertext. The live 'ciphertext' wire is destroyed when the
  // encryption core is reset / keeps clocking, so decryption must read this instead.
  reg  [63:0] cipher_hold;

  // Decryption inputs and outputs
  reg  [63:0] decryption_key;
  reg         decryption_valid;
  wire [63:0] decrypted_plaintext;
  wire        plain_data_valid;

  // Instantiate encryption DUT
  des_encryption dut_encryption (
      .plaintext(plaintext),
      .key(encryption_key),
      .clk(clk),
      .rst(rst),
      .plian_key_valid(encryption_valid),
      .ciphertext(ciphertext),
      .cipher_data_valid(cipher_data_valid)
  );

  // Instantiate decryption DUT
  des_decryption dut_decryption (
      .ciphertext(cipher_hold),
      .key(decryption_key),
      .clk(clk),
      .rst(rst),
      .cipher_key_valid(decryption_valid),
      .plaintext(decrypted_plaintext),
      .plain_data_valid(plain_data_valid)
  );

  // 10 ns clock period
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  task automatic run_case;
    input [63:0] test_plaintext;
    input [63:0] test_key;
    input [63:0] expected_ciphertext;
    input check_expected_cipher;
    input [8*32-1:0] case_name;
    integer timeout_count;
    integer enc_cycles, dec_cycles;
    begin
      // Reset encryption and decryption modules
      rst = 1'b0;
      repeat (2) @(posedge clk);
      @(negedge clk);
      rst              = 1'b1;

      plaintext        = test_plaintext;
      encryption_key   = test_key;
      encryption_valid = 1'b1;
      decryption_valid = 1'b0;

      // Wait for ciphertext
      timeout_count    = 0;
      enc_cycles       = 0;
      while (!cipher_data_valid && timeout_count < 40) begin
        @(negedge clk);
        timeout_count = timeout_count + 1;
        enc_cycles    = timeout_count;
      end

      if (!cipher_data_valid) begin
        $fatal(1, "Encryption timeout");
      end

      // Capture the good ciphertext NOW, before the encryption core is reset
      cipher_hold = ciphertext;

      if (check_expected_cipher && ciphertext !== expected_ciphertext) begin
        $fatal(1, "Encryption mismatch: plaintext=%h key=%h expected=%h actual=%h", test_plaintext,
               test_key, expected_ciphertext, ciphertext);
      end

      // Reset again before decryption
      @(negedge clk);
      encryption_valid = 1'b0;
      rst              = 1'b0;
      repeat (2) @(posedge clk);
      @(negedge clk);
      rst = 1'b1;

      decryption_key = test_key;
      decryption_valid = 1'b1;

      // Wait for decrypted plaintext
      timeout_count = 0;
      dec_cycles    = 0;
      while (!plain_data_valid && timeout_count < 40) begin
        @(negedge clk);
        timeout_count = timeout_count + 1;
        dec_cycles    = timeout_count;
      end

      if (!plain_data_valid) begin
        $fatal(1, "Decryption timeout");
      end

      if (decrypted_plaintext !== test_plaintext) begin
        $fatal(1, "Decryption mismatch: expected=%h actual=%h", test_plaintext,
               decrypted_plaintext);
      end

      @(negedge clk);
      decryption_valid = 1'b0;

      $display("[%0t] PASS %0s | pt=%h key=%h ct=%h | enc=%0d dec=%0d cycles", $time, case_name,
               test_plaintext, test_key, cipher_hold, enc_cycles, dec_cycles);
    end
  endtask

  initial begin
    $timeformat(-9, 3, " ns", 12);

    cipher_hold      = 64'b0;
    plaintext        = 64'b0;
    encryption_key   = 64'b0;
    encryption_valid = 1'b0;
    decryption_key   = 64'b0;
    decryption_valid = 1'b0;
    rst              = 1'b0;

    $display("[%0t] Starting DES self-checking testbench", $time);

    // Optional waveform-style trace: vsim ... +VERBOSE  (off by default)
    if ($test$plusargs("VERBOSE"))
      $monitor(
          "[%0t] rst=%b enc_v=%b cipher_v=%b dec_v=%b plain_v=%b",
          $time,
          rst,
          encryption_valid,
          cipher_data_valid,
          decryption_valid,
          plain_data_valid
      );

    run_case(64'h0000000000000000, 64'h0000000000000000, 64'h8CA64DE9C1B123A7, 1'b1, "zero pt/key");

    run_case(64'h0123456789ABCDEF, 64'h133457799BBCDFF1, 64'h85E813540F0AB405, 1'b1,
             "standard DES vector");

    run_case(64'hFEDCBA9876543210, 64'h0123456789ABCDEF, 64'h12C626AF058B433B, 1'b1,
             "reversed pattern");

    run_case(64'hAAAAAAAAAAAAAAAA, 64'h5555555555555555, 64'h343A09F9B2CB5CCA, 1'b1,
             "alternating pattern");

    $display("[%0t] ALL 4 DES TEST CASES PASSED", $time);

    $stop;
  end

endmodule
