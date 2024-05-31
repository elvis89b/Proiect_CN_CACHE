module four_way_set #(parameter ADDRESS_WORD_SIZE = 32, parameter TAG_SIZE = 19, parameter BLOCK_SIZE = 8, parameter WORD_SIZE = 8) (
  input clk,
  input rst_b,
  input [ADDRESS_WORD_SIZE-1:0]address_word,
  input try_read,
  input try_write,
  input [7:0]write_data,
  input [3:0]reset_age,
  input [3:0]increment_age,
  output [7:0]data,
  output [7:0]ages,
  output hit_miss,
  output [3:0]hit_miss_set
);

  // signals for each of the four lines inside a set
  reg [3:0]ready;

  //relevant data for each line inside the set
  wire [31:0]line_data;
  wire [3:0]line_hit_miss;
  wire [3:0]line_is_empty;
  wire [1:0]sel;
  
  // initialize ready signal (set to 0)
  initial begin
    ready <= 4'd0;
    //data <= 8'd0;
    //ages <= 8'd0;
    //hit_miss <= 1'b0;
  end
  
  //encodes the ready bits to a 2-bit wire that will act as a selection line for the actual target line inside the set
  encoder4to2 uut_sel (
    .in(ready),
    .out(sel)
  );
  
  //generate the four cache lines
  generate
    genvar i;
    for(i = 0 ; i < 4 ; i = i + 1) begin: cache_lines
      cache_line #(
        .ADDRESS_WORD_SIZE(ADDRESS_WORD_SIZE),
        .TAG_SIZE(TAG_SIZE),
        .BLOCK_SIZE(BLOCK_SIZE),
        .WORD_SIZE(WORD_SIZE)
      ) uut (
        .clk(clk),
        .rst_b(rst_b),
        .ready(ready[i]),
        .address_word(address_word),
        .try_read(try_read),
        .try_write(try_write),
        .write_data(write_data),
        .reset_age(reset_age[i]),
        .increment_age(increment_age[i]),
        .data(line_data[8*(i+1)-1:8*i]),
        .age(ages[2*i+1:2*i]),
        .hit_miss(line_hit_miss[i]),
        .is_empty(line_is_empty[i])
      );
    end
  endgenerate
  
  // update the hit/miss output for the set
  assign hit_miss_set = line_hit_miss;
  
  // select data form target line
  mux4to1 #(.w(8)) uut_mux_data (
    .in_0(line_data[7:0]),
    .in_1(line_data[15:8]),
    .in_2(line_data[23:16]),
    .in_3(line_data[31:24]),
    .sel(sel),
    .out(data)
  );
  
  // select hit/miss signal from target line
  mux4to1 #(.w(1)) uut_mux_hit_miss (
    .in_0(line_hit_miss[0]),
    .in_1(line_hit_miss[1]),
    .in_2(line_hit_miss[2]),
    .in_3(line_hit_miss[3]),
    .sel(sel),
    .out(hit_miss)
  );
  
  // this section determines in which of the four cache lines inside the current set must the operation be performed
  always @(posedge clk) begin
    if(line_hit_miss[0])
      ready = 4'b0001;
    else if(line_hit_miss[1])
      ready = 4'b0010;
    else if(line_hit_miss[2])
      ready = 4'b0100;
    else if(line_hit_miss[3])
      ready = 4'b1000;
    else if(line_is_empty[0])
      ready = 4'b0001;
    else if(line_is_empty[1])
      ready = 4'b0010;
    else if(line_is_empty[2])
      ready = 4'b0100;
    else if(line_is_empty[3])
      ready = 4'b1000;
    else if(ages[1:0] == 2'b11)
      ready = 4'b0001;
    else if(ages[3:2] == 2'b11)
      ready = 4'b0010;
    else if(ages[5:4] == 2'b11)
      ready = 4'b0100;
    else if(ages[7:6] == 2'b11)
      ready = 4'b1000;
    else
      ready = 4'b0000;    
  end
  
  // on reset, none of the 4 lines should be ready for operations
  always @(negedge rst_b) begin
    ready <= 4'd0;
    //data <= 8'd0;
    //ages <= 8'd0;
    //hit_miss <= 1'b0;
  end
  
endmodule
  