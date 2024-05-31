module cache_memory #(parameter ADDRESS_WORD_SIZE = 32, parameter TAG_SIZE = 19, parameter BLOCK_SIZE = 8, parameter WORD_SIZE = 8, parameter NUMBER_OF_SETS = 128) (
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

  // decoder output, determines which of the sets should receive control signals
  wire [NUMBER_OF_SETS-1:0]active;
  
  //instantiate a decoder that determines the target set, based on the address_word index field
  dec7to128 uut_decoder (
    .index(address_word[ADDRESS_WORD_SIZE-TAG_SIZE-1-:7]),
    .active(active)
  );
  
  // internal wires
  wire [NUMBER_OF_SETS-1:0]try_read_w;
  wire [NUMBER_OF_SETS-1:0]try_write_w;
  wire [4*NUMBER_OF_SETS-1:0]reset_age_w;
  wire [4*NUMBER_OF_SETS-1:0]increment_age_w;
  
  //generate tristate drivers to control where the singals are passed to
  generate
    genvar i;
    for(i = 0 ; i < NUMBER_OF_SETS ; i = i + 1) begin: tristate_drivers
      tristate_driver #(.w(1)) uut_tri_read (
        .in(try_read),
        .enable(active[i]),
        .out(try_read_w[i])
      );
      tristate_driver #(.w(1)) uut_tri_write (
        .in(try_write),
        .enable(active[i]),
        .out(try_write_w[i])
      );
      tristate_driver #(.w(4)) uut_tri_reset (
        .in(reset_age),
        .enable(active[i]),
        .out(reset_age_w[4*i+3:4*i])
      );
      tristate_driver #(.w(4)) uut_tri_increment (
        .in(increment_age),
        .enable(active[i]),
        .out(increment_age_w[4*i+3:4*i])
      );
    end
  endgenerate
  
  // more internal wires
  wire [8*NUMBER_OF_SETS-1:0]data_w;
  wire [8*NUMBER_OF_SETS-1:0]ages_w;
  wire [NUMBER_OF_SETS-1:0]hit_miss_w;
  wire [4*NUMBER_OF_SETS-1:0]hit_miss_set_w;
  
  // generate 128 sets inside the cache memory
  generate
    genvar j;
    for(j = 0 ; j < NUMBER_OF_SETS ; j = j + 1) begin: sets
      four_way_set #(
        .ADDRESS_WORD_SIZE(ADDRESS_WORD_SIZE),
        .TAG_SIZE(TAG_SIZE),
        .BLOCK_SIZE(BLOCK_SIZE),
        .WORD_SIZE(WORD_SIZE)
      ) uut_set (
        .clk(clk),
        .rst_b(rst_b),
        .address_word(address_word),
        .try_read(try_read_w[j]),
        .try_write(try_write_w[j]),
        .write_data(write_data),
        .reset_age(reset_age_w[4*j+3:4*j]),
        .increment_age(increment_age_w[4*j+3:4*j]),
        .data(data_w[8*j+7:8*j]),
        .ages(ages_w[8*j+7:8*j]),
        .hit_miss(hit_miss_w[j]),
        .hit_miss_set(hit_miss_set_w[4*j+3:4*j])
      );
    end
  endgenerate
  
  //instantiate a mux to select data from the target set
  mux128to1 #(.w(8)) uut_mux_data (
    .in(data_w),
    .sel(address_word[ADDRESS_WORD_SIZE-TAG_SIZE-1-:7]),
    .out(data)
  );
  
  //instantiate a mux to select ages form the target set
  mux128to1 #(.w(8)) uut_mux_ages (
    .in(ages_w),
    .sel(address_word[ADDRESS_WORD_SIZE-TAG_SIZE-1-:7]),
    .out(ages)
  );
  
  //instantiate a mux to select hit_miss form target set
  mux128to1 #(.w(1)) uut_mux_hit (
    .in(hit_miss_w),
    .sel(address_word[ADDRESS_WORD_SIZE-TAG_SIZE-1-:7]),
    .out(hit_miss)
  );
  
  //instantiate a mux to select hit_miss_set form target set
  mux128to1 #(.w(4)) uut_mux_hit_set (
    .in(hit_miss_set_w),
    .sel(address_word[ADDRESS_WORD_SIZE-TAG_SIZE-1-:7]),
    .out(hit_miss_set)
  );

endmodule