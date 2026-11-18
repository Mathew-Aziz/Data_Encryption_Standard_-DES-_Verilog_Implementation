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
      .ciphertext(ciphertext),
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
    integer timeout_count;
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
      while (!cipher_data_valid && timeout_count < 40) begin
        @(negedge clk);
        timeout_count = timeout_count + 1;
      end

      if (!cipher_data_valid) begin
        $fatal(1, "Encryption timeout");
      end

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
      while (!plain_data_valid && timeout_count < 40) begin
        @(negedge clk);
        timeout_count = timeout_count + 1;
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

      $display("PASS: plaintext=%h key=%h ciphertext=%h", test_plaintext, test_key, ciphertext);
    end
  endtask

  initial begin
    $timeformat(-9, 3, " ns", 12);

    plaintext        = 64'b0;
    encryption_key   = 64'b0;
    encryption_valid = 1'b0;
    decryption_key   = 64'b0;
    decryption_valid = 1'b0;
    rst              = 1'b0;

    $display("[%0t] Starting DES self-checking testbench", $time);
    $display("[%0t] Initializing inputs and applying reset", $time);

    $monitor(
        "[%0t] rst=%b pt=%h enc_key=%h enc_valid=%b cipher=%h cipher_valid=%b dec_key=%h dec_valid=%b plain=%h plain_valid=%b",
        $time, rst, plaintext, encryption_key, encryption_valid, ciphertext, cipher_data_valid,
        decryption_key, decryption_valid, decrypted_plaintext, plain_data_valid);

    run_case(64'h0000000000000000, 64'h0000000000000000, 64'h8CA64DE9C1B123A7, 1'b1);

    $display("[%0t] Completed test case 1: zero plaintext/key", $time);

    run_case(64'h0123456789ABCDEF, 64'h133457799BBCDFF1, 64'h85E813540F0AB405, 1'b1);

    $display("[%0t] Completed test case 2: standard DES vector", $time);

    run_case(64'hFEDCBA9876543210, 64'h0123456789ABCDEF, 64'hED3D2F1B1A7C7B4F, 1'b1);

    $display("[%0t] Completed test case 3: reversed-pattern vector", $time);

    run_case(64'hAAAAAAAAAAAAAAAA, 64'h5555555555555555, 64'h0000000000000000, 1'b0);

    $display("[%0t] Completed test case 4: alternating-pattern round trip", $time);
    $display("[%0t] ALL 4 DES TEST CASES PASSED", $time);

    $monitoroff;
    $stop;
  end

endmodule
