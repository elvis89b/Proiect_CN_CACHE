library verilog;
use verilog.vl_types.all;
entity mux128to1 is
    generic(
        w               : integer := 8
    );
    port(
        \in\            : in     vl_logic_vector;
        sel             : in     vl_logic_vector(6 downto 0);
        \out\           : out    vl_logic_vector
    );
end mux128to1;
