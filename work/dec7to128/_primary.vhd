library verilog;
use verilog.vl_types.all;
entity dec7to128 is
    port(
        index           : in     vl_logic_vector(6 downto 0);
        active          : out    vl_logic_vector(127 downto 0)
    );
end dec7to128;
