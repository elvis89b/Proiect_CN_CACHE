library verilog;
use verilog.vl_types.all;
entity mux4to1 is
    generic(
        w               : integer := 64
    );
    port(
        in_0            : in     vl_logic_vector;
        in_1            : in     vl_logic_vector;
        in_2            : in     vl_logic_vector;
        in_3            : in     vl_logic_vector;
        sel             : in     vl_logic_vector(1 downto 0);
        \out\           : out    vl_logic_vector
    );
end mux4to1;
