module encoder4to2_tb;
  reg [3:0]in;
  wire [1:0]out;
  
  encoder4to2 uut (
    .in(in),
    .out(out)
  );
  
  integer i;
  initial begin
    in = $urandom_range(0, 15);
    $display("Time\tin\tout");
    $monitor("%0t\t%b\t%b", $time, in, out);
    for(i = 1 ; i < 10 ; i = i + 1)
    begin
      #10
      in = $urandom_range(0, 15);
    end
    #10 in = 4'b0001;
    #10 in = 4'b0010;
    #10 in = 4'b0100;
    #10 in = 4'b1000;
  end
  
endmodule