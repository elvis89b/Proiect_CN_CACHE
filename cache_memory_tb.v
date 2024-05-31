module cache_memory_tb;
  reg clk;
  reg rst_b;
  reg [31:0]address_word;
  reg try_read;
  reg try_write;
  reg [7:0]write_data;
  reg [3:0]reset_age;
  reg [3:0]increment_age;
  wire [7:0]data;
  wire [7:0]ages;
  wire hit_miss;
  wire [3:0]hit_miss_set;
  
  cache_memory uut (
    .clk(clk),
    .rst_b(rst_b),
    .address_word(address_word),
    .try_read(try_read),
    .try_write(try_write),
    .write_data(write_data),
    .reset_age(reset_age),
    .increment_age(increment_age),
    .data(data),
    .ages(ages),
    .hit_miss(hit_miss),
    .hit_miss_set(hit_miss_set)
  );
  
  localparam RST_PULSE = 10;
  localparam CLK_CYCLES = 100;
  localparam CLK_PERIOD = 100;
  
  initial begin
    clk = 1'b0;
    repeat (2 * CLK_CYCLES) #(CLK_PERIOD / 2) clk = ~clk;
  end
  
  initial begin
    rst_b = 1'b0;
    #(RST_PULSE) rst_b = 1'b1;
  end
  
  initial begin
    address_word = $random;
    repeat (CLK_CYCLES) #(CLK_PERIOD) address_word = $random;
  end
  
  initial begin
    try_read = $urandom_range(0, 1);
    try_write = ~try_read;
    repeat (CLK_CYCLES) begin
      #(CLK_PERIOD)
      try_read = $urandom_range(0, 1);
      try_write = ~try_read;
    end
  end
  
  initial begin
    write_data = $urandom_range(0, 255);
    repeat (CLK_CYCLES) #(CLK_PERIOD) write_data = $urandom_range(0, 255);
  end
  
  initial begin
    reset_age = $urandom_range(0, 15);
    increment_age[0] = ~reset_age[0];
    increment_age[1] = ~reset_age[1];
    increment_age[2] = ~reset_age[2];
    increment_age[3] = ~reset_age[3];
    repeat (CLK_CYCLES) begin
      #(CLK_PERIOD)
      reset_age = $urandom_range(0, 15);
      increment_age[0] = ~reset_age[0];
      increment_age[1] = ~reset_age[1];
      increment_age[2] = ~reset_age[2];
      increment_age[3] = ~reset_age[3];
    end
  end
  
endmodule