module mux128to1_tb;
  reg [255:0]in;
  reg [6:0]sel;
  wire [1:0]out;
  
  mux128to1 #(.w(2)) uut (
    .in(in),
    .sel(sel),
    .out(out)
  );
  
  integer i;
  initial begin
    in = {8{$random}};
    sel = $urandom_range(0, 127);
    $display("Time\tin\tsel\tout");
    $monitor("%0t\t%b\t%b\t%b", $time, in, sel, out);
    for(i = 1 ; i < 10 ; i = i + 1) begin
      #10
      in = {8{$random}};
      sel = $urandom_range(0, 127);
    end
  end
  
endmodule