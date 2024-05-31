library verilog;
use verilog.vl_types.all;
entity control_unit is
    generic(
        ADDRESS_WORD_SIZE: integer := 32
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        opcode          : in     vl_logic;
        hit_miss        : in     vl_logic;
        hit_miss_set    : in     vl_logic_vector(3 downto 0);
        ages            : in     vl_logic_vector(7 downto 0);
        address_word    : out    vl_logic_vector;
        try_read        : out    vl_logic;
        try_write       : out    vl_logic;
        write_data      : out    vl_logic_vector(7 downto 0);
        reset_age       : out    vl_logic_vector(3 downto 0);
        increment_age   : out    vl_logic_vector(3 downto 0)
    );
end control_unit;
