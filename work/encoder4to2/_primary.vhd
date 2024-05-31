library verilog;
use verilog.vl_types.all;
entity encoder4to2 is
    port(
        \in\            : in     vl_logic_vector(3 downto 0);
        \out\           : out    vl_logic_vector(1 downto 0)
    );
end encoder4to2;
