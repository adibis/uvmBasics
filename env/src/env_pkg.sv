`ifndef ENV_PKG__SV
`define ENV_PKG__SV
package env_pkg;

    // Standard UVM import & include:
    import uvm_pkg::*;

    `include "uvm_macros.svh"

    // Any further package imports:
    import apb_pkg::*;
    import apb_regs_pkg::*;

    // Includes:
    `include "env_cfg.sv"
    `include "scoreboard.sv"
    `include "env.sv"

endpackage: env_pkg
`endif
