library verilog;
use verilog.vl_types.all;
entity four_way_set is
    generic(
        ADDRESS_WORD_SIZE: integer := 32;
        TAG_SIZE        : integer := 19;
        BLOCK_SIZE      : integer := 8;
        WORD_SIZE       : integer := 8
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        address_word    : in     vl_logic_vector;
        try_read        : in     vl_logic;
        try_write       : in     vl_logic;
        write_data      : in     vl_logic_vector(7 downto 0);
        reset_age       : in     vl_logic_vector(3 downto 0);
        increment_age   : in     vl_logic_vector(3 downto 0);
        data            : out    vl_logic_vector(7 downto 0);
        ages            : out    vl_logic_vector(7 downto 0);
        hit_miss        : out    vl_logic;
        hit_miss_set    : out    vl_logic_vector(3 downto 0)
    );
end four_way_set;
