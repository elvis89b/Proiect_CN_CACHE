module control_unit #(parameter ADDRESS_WORD_SIZE = 32)(
  input clk,
  input rst_b,
  input opcode,
  input hit_miss,
  input [3:0]hit_miss_set,
  input [7:0]ages,
  output reg [ADDRESS_WORD_SIZE-1:0]address_word,
  output reg try_read,
  output reg try_write,
  output reg [7:0]write_data,
  output reg [3:0]reset_age,
  output reg [3:0]increment_age
);

  // fsm states
  localparam IDLE = 3'b000;
  localparam TRY_READ = 3'b001;
  localparam TRY_WRITE = 3'b010;
  localparam STALL_1 = 3'b011;
  localparam STALL_2 = 3'b100;
  localparam UPDATE_AGES = 3'b101;
  localparam CHECK_STATUS = 3'b110;
  
  reg [2:0]current_state;
  reg [2:0]next_state;
  
  integer i;
  integer replace_index;
  
  //initialize control unit
  initial begin
    current_state <= IDLE;
    next_state <= IDLE;
    address_word = {ADDRESS_WORD_SIZE-1{1'b0}};
    try_read = 1'b0;
    try_write = 1'b0;
    write_data = 8'd0;
    reset_age = 4'd0;
    increment_age = 4'd0;
    replace_index = 1'b0;
  end
  
  //control unit logic
  always @(*) begin
    case(current_state)
        IDLE:
        begin
          // in the idle state, all signals should be 0
          address_word = {ADDRESS_WORD_SIZE-1{1'b0}};
          try_read = 1'b0;
          try_write = 1'b0;
          write_data = 8'd0;
          reset_age = 4'd0;
          increment_age = 4'd0;
          replace_index = 1'b0;
          if(opcode)
            next_state = TRY_WRITE; // opcode 1 stands for write, so the next state should be TRY_WRITE
          else
            next_state = TRY_READ;  //opcode 0 stands for read, so the next state should be TRY_READ
        end
        TRY_READ:
        begin
          // set try_read signal to 1, generate an address_word and go to the CHECK_STATUS state
          try_read = 1'b1;
          address_word = $random;
          next_state = CHECK_STATUS;
        end
        TRY_WRITE:
        begin
          // set try_write signal to 1, generate an address_word, as well as a byte of data to be written and go to the CHECK_STATUS state
          try_write = 1'b1;
          address_word = $random;
          write_data = $urandom_range(0, 255);
          next_state = CHECK_STATUS;
        end
        STALL_1:
        begin
          // simulate main memory access
          next_state = STALL_2;
        end
        STALL_2:
        begin
          // simulate main memory access
          next_state = UPDATE_AGES;
        end
        UPDATE_AGES:
        begin
          // find the index of the target line inside the current set and reset its age (since it was used right now)
          for(i = 0 ; i < 4 ; i = i + 1) begin
            if(hit_miss_set[i]) begin
              reset_age[i] = 1'b1;
              replace_index = i;
            end
          end
          // increment all ages that were less than the one you plan to reset
          for(i = 0 ; i < 4 ; i = i + 1) begin
            if(ages[2*i+:1] < ages[2*replace_index+:1])
              increment_age[i] = 1'b1;
          end
          next_state = IDLE;
        end
        CHECK_STATUS:
        begin
          if(hit_miss)
            next_state = UPDATE_AGES; // in case of a hit, update the ages inside the target set
          else
            next_state = STALL_1;     // in case of a miss, bring data from main memory
        end
        default: next_state = IDLE;   // you shouldn't be here. how did you get here ?
      endcase
  end
    
  
  always @(posedge clk or negedge rst_b) begin
    if(clk)
      current_state <= next_state;  // move to the next state
    else
      current_state <= IDLE;  // on reset, you should go to the initial state
  end

endmodule
  
  