library verilog;
use verilog.vl_types.all;
entity sin_addr is
    port(
        clock           : in     vl_logic;
        q               : out    vl_logic_vector(8 downto 0)
    );
end sin_addr;
