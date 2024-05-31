module mux4to1_tb;
  reg signed [7:0]in_0_8;
  reg signed [15:0]in_0_16;
  reg signed [7:0]in_1_8;
  reg signed [15:0]in_1_16;
  reg signed [7:0]in_2_8;
  reg signed [15:0]in_2_16;
  reg signed [7:0]in_3_8;
  reg signed [15:0]in_3_16;
  reg [1:0]sel;
  wire signed [7:0]out_8;
  wire signed [15:0]out_16;
  
  mux4to1 #(.w(8)) uut_8 (
    .in_0(in_0_8),
    .in_1(in_1_8),
    .in_2(in_2_8),
    .in_3(in_3_8),
    .sel(sel),
    .out(out_8)
  );
  
  mux4to1 #(.w(16)) uut_16 (
    .in_0(in_0_16),
    .in_1(in_1_16),
    .in_2(in_2_16),
    .in_3(in_3_16),
    .sel(sel),
    .out(out_16)
  );
  
  integer i;
  initial begin
    in_0_8 = $urandom_range(0, 255) - 128;
    in_1_8 = $urandom_range(0, 255) - 128;
    in_2_8 = $urandom_range(0, 255) - 128;
    in_3_8 = $urandom_range(0, 255) - 128;
    sel = $urandom_range(0, 3);
    $display("Time\tin_0\tin_1\tin_2\tin_3\tsel\t\tout");
    $monitor("%0t\t%d\t%d\t%d\t%d\t%d\t\t%d", $time, in_0_8, in_1_8, in_2_8, in_3_8, sel, out_8);
    for(i = 1 ; i < 10 ; i = i + 1)
    begin
      #10
      in_0_8 = $urandom_range(0, 255) - 128;
      in_1_8 = $urandom_range(0, 255) - 128;
      in_2_8 = $urandom_range(0, 255) - 128;
      in_3_8 = $urandom_range(0, 255) - 128;
      sel = $urandom_range(0, 3);
    end
  end
  
  initial begin
    #100
    $display();
    $display();
    $display();
  end
  
  initial begin
    #110
    in_0_16 = $urandom_range(0, 65535) - 32768;
    in_1_16 = $urandom_range(0, 65535) - 32768;
    in_2_16 = $urandom_range(0, 65535) - 32768;
    in_3_16 = $urandom_range(0, 65535) - 32768;
    sel = $urandom_range(0, 3);
    $display("Time\tin_0\tin_1\tin_2\tin_3\tsel\t\tout");
    $monitor("%0t\t%d\t%d\t%d\t%d\t%d\t\t%d", $time, in_0_16, in_1_16, in_2_16, in_3_16, sel, out_16);
    for(i = 1 ; i < 10 ; i = i + 1)
    begin
      #10
      in_0_16 = $urandom_range(0, 65535) - 32768;
      in_1_16 = $urandom_range(0, 65535) - 32768;
      in_2_16 = $urandom_range(0, 65535) - 32768;
      in_3_16 = $urandom_range(0, 65535) - 32768;
      sel = $urandom_range(0, 3);
    end
  end
  
endmodule