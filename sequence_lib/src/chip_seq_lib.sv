`ifndef CHIP_SEQ_LIB__SV
`define CHIP_SEQ_LIB__SV
package chip_seq_lib_pkg;

    // Standard UVM import & include:
    import uvm_pkg::*;

    `include "uvm_macros.svh"

    // Any further package imports:
    import apb_pkg::*;
    import apb_regs_pkg::*;

    // Includes:
    `include "apb_register_seq.sv"

endpackage: chip_seq_lib_pkg
`endif
