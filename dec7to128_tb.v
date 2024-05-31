module dec7to128_tb;
  reg [6:0]index;
  wire [127:0]active;
  
  dec7to128 uut (
    .index(index),
    .active(active)
  );
  
  integer i;
  initial begin
    index = $urandom_range(0, 127);
    $display("Time\tindex\tactive");
    $monitor("%0t\t%b\t%b", $time, index, active);
    for(i = 1 ; i < 20 ; i = i + 1)
      #10 index = $urandom_range(0, 127);
  end
  
endmodule