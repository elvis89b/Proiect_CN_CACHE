library verilog;
use verilog.vl_types.all;
entity and_wordgate is
    generic(
        w               : integer := 8
    );
    port(
        \in\            : in     vl_logic_vector;
        \AND_\          : out    vl_logic
    );
end and_wordgate;
