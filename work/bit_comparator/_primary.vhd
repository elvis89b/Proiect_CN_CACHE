library verilog;
use verilog.vl_types.all;
entity bit_comparator is
    port(
        b0              : in     vl_logic;
        b1              : in     vl_logic;
        eq              : out    vl_logic
    );
end bit_comparator;
