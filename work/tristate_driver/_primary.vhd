library verilog;
use verilog.vl_types.all;
entity tristate_driver is
    generic(
        w               : integer := 8
    );
    port(
        \in\            : in     vl_logic_vector;
        enable          : in     vl_logic;
        \out\           : out    vl_logic_vector
    );
end tristate_driver;
