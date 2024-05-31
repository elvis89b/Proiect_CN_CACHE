library verilog;
use verilog.vl_types.all;
entity cache_controller is
    generic(
        ADDRESS_WORD_SIZE: integer := 32;
        TAG_SIZE        : integer := 19;
        BLOCK_SIZE      : integer := 8;
        WORD_SIZE       : integer := 8;
        NUMBER_OF_SETS  : integer := 128
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        opcode          : in     vl_logic;
        data            : out    vl_logic_vector(7 downto 0);
        hit_miss        : out    vl_logic
    );
end cache_controller;
