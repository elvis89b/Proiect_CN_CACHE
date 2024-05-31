module bitwise_comparator_tb;
  reg [7:0]in_0_8;
  reg [7:0]in_1_8;
  reg [31:0]in_0_32;
  reg [31:0]in_1_32;
  wire eq_8;
  wire eq_32;
  
  bitwise_comparator uut_8 (
    .in_0(in_0_8),
    .in_1(in_1_8),
    .eq(eq_8)
  );
  
  bitwise_comparator #(.w(32)) uut_32 (
    .in_0(in_0_32),
    .in_1(in_1_32),
    .eq(eq_32)
  );
  
  integer i;
  initial begin
    in_0_8 = $urandom_range(0, 255) - 128;
    in_1_8 = $urandom_range(0, 255) - 128;
    $display("Time\tin_0\t\tin_1\t\teq");
    $monitor("%0t\t%b\t%b\t%b", $time, in_0_8, in_1_8, eq_8);
    for(i = 1 ; i < 10 ; i = i + 1)
    begin
      #10
      in_0_8 = $urandom_range(0, 255) - 128;
      in_1_8 = $urandom_range(0, 255) - 128;
    end
    #10
    in_0_8 = 8'hac;
    in_1_8 = 8'hac;
  end
  
  initial begin
    #110
    $display();
    $display();
    $display();
  end
  
  initial begin
    #120
    in_0_32 = $random;
    in_1_32 = $random;
    $display("Time\tin_0\t\t\t\t\tin_1\t\t\t\t\teq");
    $monitor("%0t\t%b\t%b\t%b", $time, in_0_32, in_1_32, eq_32);
    for(i = 1 ; i < 10 ; i = i + 1)
    begin
      #10
      in_0_32 = $random;
      in_1_32 = $random;
    end
    #10
    in_0_32 = 32'hac09f57d;
    in_1_32 = 32'hac09f57d;
  end
  
endmodule