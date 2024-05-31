module and_wordgate_tb;
  reg [7:0]in_8;
  reg [31:0]in_32;
  wire AND_8;
  wire AND_32;
  
  and_wordgate uut_8 (
    .in(in_8),
    .AND_(AND_8)
  );
  
  and_wordgate #(.w(32)) uut_32 (
    .in(in_32),
    .AND_(AND_32)
  );
  
  integer i;
  initial begin
    in_8 = $urandom_range(0, 255);
    $display("Time\tin_0\t\tAND_8");
    $monitor("%0t\t%b\t%b", $time, in_8, AND_8);
    for(i = 1 ; i < 10 ; i = i + 1)
    begin
      #10
      in_8 = $urandom_range(0, 255);
    end
    #10 in_8 = 8'hff;
  end
  
  initial begin
    #110
    $display();
    $display();
    $display();
  end
  
  initial begin
    #120
    in_32 = $random;
    $display("Time\tin_0\t\t\t\t\tAND_32");
    $monitor("%0t\t%b\t%b", $time, in_32, AND_32);
    for(i = 1 ; i < 10 ; i = i + 1)
    begin
      #10
      in_32 = $random;
    end
    #10 in_32 = 32'hffffffff;
  end
  
endmodule