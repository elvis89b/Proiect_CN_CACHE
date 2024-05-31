module tristate_driver_tb;
  reg [7:0]in;
  reg enable;
  tri [7:0]out;
  
  tristate_driver uut (
    .in(in),
    .enable(enable),
    .out(out)
  );
  
  integer i;
  initial begin
    in = $urandom_range(0, 255);
    enable = $urandom_range(0, 1);
    $display("Time\tin\tenable\tout");
    $monitor("%0t\t%b\t%b\t%b", $time, in, enable, out);
    for(i = 1 ; i < 10 ; i = i + 1) begin
      #10
      in = $urandom_range(0, 255);
      enable = $urandom_range(0, 1);
    end
  end
  
endmodule
    