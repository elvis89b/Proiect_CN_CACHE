module bit_comparator_tb;
  reg b0;
  reg b1;
  wire eq;
  
  bit_comparator uut (
    .b0(b0),
    .b1(b1),
    .eq(eq)
  );
  
  integer i;
  initial begin
    {b1, b0} = 0;
    $display("Time\tb0\tb1\teq");
    $monitor("%0t\t%b\t%b\t%b", $time, b0, b1, eq);
    for(i = 1 ; i < 4 ; i = i + 1)
    begin
      #10
      {b1, b0} = i;
    end
  end
  
endmodule