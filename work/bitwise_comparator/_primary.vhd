library verilog;
use verilog.vl_types.all;
entity bitwise_comparator is
    generic(
        w               : integer := 8
    );
    port(
        in_0            : in     vl_logic_vector;
        in_1            : in     vl_logic_vector;
        eq              : out    vl_logic
    );
end bitwise_comparator;
