`ifndef APB_SEQ_ITEM__SV
`define APB_SEQ_ITEM__SV
class apb_seq_item extends uvm_sequence_item;
  // Direction of the transaction. 0 = Read, 1 = Write.
  typedef enum bit {TR_READ, TR_WRITE} trRw_e;

  // Each transaction has address, data and type.
  rand trRw_e          tr_rw;
  rand logic   [15:0]  tr_addr;
  rand logic   [15:0]  tr_wdata;
  rand logic   [15:0]  tr_rdata;
  rand logic tr_error;

  function new(string name = "<anon>");
    super.new(name);
  endfunction: new

  `uvm_object_utils_begin(apb_seq_item)
      `uvm_field_enum(trRw_e, tr_rw, UVM_ALL_ON)
      `uvm_field_int(tr_addr, UVM_ALL_ON)
      `uvm_field_int(tr_rdata, UVM_ALL_ON)
      `uvm_field_int(tr_wdata, UVM_ALL_ON)
      `uvm_field_int(tr_error, UVM_ALL_ON)
  `uvm_object_utils_end

endclass: apb_seq_item
`endif
