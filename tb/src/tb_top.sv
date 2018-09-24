`ifndef TB_TOP__SV
`define TB_TOP__SV

import uvm_pkg::*;
`include "uvm_macros.svh"

module top;

reg pclk;

APB_If    apb_slave_if(pclk);
APB_dummy DUT(
    .PCLK   (pclk),
    .PENABLE(apb_slave_if.penable),
    .PSEL   (apb_slave_if.psel   ),   //   Connect DUT ports to
    .PWRITE (apb_slave_if.pwrite ),   //   appropriate signals in the
    .PADDR  (apb_slave_if.paddr  ),   //   test access interface
    .PWDATA (apb_slave_if.pwdata ),
    .PRDATA (apb_slave_if.prdata ),
    .PERROR (apb_slave_if.perror ),
    .PREADY (apb_slave_if.pready )
);

initial begin
    pclk = 0;
    #5ns;
    forever #5ns pclk = !pclk;
end

initial begin
    // Set interfaces for each of the agents in the testbench from here.
    uvm_config_db#(virtual APB_If)::set(null, "uvm_test_top", "APB_If", apb_slave_if);
    run_test();
end

endmodule: top
`endif
