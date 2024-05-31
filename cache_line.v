`define TAG_SIZE 8 //bits
`define WORD_SIZE 2 // bytes
`define BLOCK_SIZE 4 // words
`define ADDRESS_WORD_SIZE 32 // bits

module cache_line #(parameter ADDRESS_WORD_SIZE = 32, parameter TAG_SIZE = 19, parameter BLOCK_SIZE = 8, parameter WORD_SIZE = 8)(
  input clk,
  input rst_b,
  input ready,  // signal is active only when the operation (read/write) is ready to be performed
  input [ADDRESS_WORD_SIZE-1:0]address_word,
  input try_read,
  input try_write,
  input [7:0]write_data,  // data to be written (1 byte)
  input reset_age,
  input increment_age,
  output reg [7:0]data, // data read/written from/to the cache line
  output reg [1:0]age,  // the age of the cache line
  output reg hit_miss,  // signal to determine if the current operation resulted in a hit or a miss
  output reg is_empty
);

  // data stored inside each cache line
  reg valid_bit; 
  reg [TAG_SIZE-1:0]tag;
  reg [BLOCK_SIZE*WORD_SIZE*8-1:0]block_of_data;
  reg [1:0]age_bits;
  reg dirty_bit;
  
  wire matching_tags;
  wire [1:0]block_offset;
  wire word_offset;
  wire end_index;
  
  assign word_offset = address_word[0]; 
  assign block_offset = address_word[2:1];
  assign end_index = block_offset * WORD_SIZE * 8 + (word_offset + 1) * 8 - 1;  // end index inside the current block of data where the operation should be performed
  
  // initialize cache line data
  initial begin
    is_empty <= 1'b1;
    data <= 8'd0;
    valid_bit <= 1'b0;
    tag <= {TAG_SIZE{1'b0}};
    block_of_data <= {BLOCK_SIZE*WORD_SIZE*8{1'b0}};
    age_bits <= 2'b00;
    dirty_bit <= 1'b0;
    age <= 2'b00;
    hit_miss <= 1'b0;
  end
  
  // instantiate a comparator for the tags
  bitwise_comparator #(.w(TAG_SIZE)) uut_comp (
    .in_0(tag),
    .in_1(address_word[ADDRESS_WORD_SIZE-1-:TAG_SIZE]),
    .eq(matching_tags)
  );
  
  //assign hit_miss = matching_tags & valid_bit;
  
  always @(posedge clk) begin
    
    // determine if we have a hit or a miss
    hit_miss = matching_tags & valid_bit;
    
    // perform operations only when ready is active
    if(ready)
      begin
    
      if(try_read)
        if(hit_miss)
          data = block_of_data[end_index-:8]; // in case of a read hit, send the data to the output
        else
          begin
          // in case of a read miss, update the valid bit, simuate bringing a block from the main memory and then send the data to the output
          valid_bit = 1'b1;
          data = {BLOCK_SIZE*WORD_SIZE*8/32{$random}};
          tag = address_word[ADDRESS_WORD_SIZE-2:ADDRESS_WORD_SIZE-9];
          end
    
      if(try_write)
        if(hit_miss) begin
          // in case of a write hit, update the data inside of the current cache line, send it to the output and mark the current cache line as dirty
          block_of_data[end_index-:8] = write_data;
          data = write_data;
          dirty_bit = 1'b1;
        end
        else
          begin
          // in case of a write miss, update the valid bit, simulate bringing a block form the main memory and then update the data inside of the current cache line, send it to the output and mark the current cache line as dirty
          valid_bit = 1'b1;
          block_of_data = $random;
          block_of_data[end_index-:8] = write_data;
          data = write_data;
          dirty_bit = 1'b1;
          tag = address_word[ADDRESS_WORD_SIZE-2:ADDRESS_WORD_SIZE-9];
          end
        
      if(reset_age)
        age_bits = 2'b00; // reset the age of the current cache line
      
      if(increment_age)
        age_bits = age_bits + 1;  // increment the age of the current cache line
        
      end
      
  end
  
  always @(posedge clk or negedge rst_b) begin
    if(clk)
      begin
        age <= age_bits;  // on each clock, send the age to the output
        is_empty <= ~valid_bit;
      end
    else
      begin
      // on reset, everything inside the cache line should be 0
      data <= 8'd0;
      valid_bit <= 1'b0;
      tag <= {TAG_SIZE{1'b0}};
      block_of_data <= {BLOCK_SIZE*WORD_SIZE*8{1'b0}};
      age_bits <= 2'b00;
      dirty_bit <= 1'b0;
      end
  end
  
endmodule