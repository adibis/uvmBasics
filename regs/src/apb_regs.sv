`ifndef APB_REGS__SV
`define APB_REGS__SV
class apb_reg_0 extends uvm_reg;
    `uvm_object_utils(apb_reg_0)

    rand uvm_reg_field lower_data;
    rand uvm_reg_field upper_data;

    function new(string name = "apb_reg_0");
        super.new(
            .name(name),
            .n_bits(16),
            .has_coverage(UVM_NO_COVERAGE)
        );
    endfunction : new

    virtual function void build();
        lower_data = uvm_reg_field::type_id::create("lower_data");
        lower_data.configure(
            .parent(this),
            .size(8),
            .lsb_pos(0),
            .access("WO"),
            .volatile(0),
            .reset(0),
            .has_reset(1),
            .is_rand(1),
            .individually_accessible(0)
        );
        upper_data = uvm_reg_field::type_id::create("upper_data");
        upper_data.configure(
            .parent(this),
            .size(8),
            .lsb_pos(8),
            .access("WO"),
            .volatile(0),
            .reset(0),
            .has_reset(1),
            .is_rand(1),
            .individually_accessible(0)
        );
    endfunction : build
endclass : apb_reg_0

class apb_reg_1 extends uvm_reg;
    `uvm_object_utils(apb_reg_1)

    rand uvm_reg_field lower_data;
    rand uvm_reg_field upper_data;

    function new(string name = "apb_reg_1");
        super.new(
            .name(name),
            .n_bits(16),
            .has_coverage(UVM_NO_COVERAGE)
        );
    endfunction : new

    virtual function void build();
        lower_data = uvm_reg_field::type_id::create("lower_data");
        lower_data.configure(
            .parent(this),
            .size(8),
            .lsb_pos(0),
            .access("RO"),
            .volatile(0),
            .reset(0),
            .has_reset(1),
            .is_rand(1),
            .individually_accessible(0)
        );
        upper_data = uvm_reg_field::type_id::create("upper_data");
        upper_data.configure(
            .parent(this),
            .size(8),
            .lsb_pos(8),
            .access("RO"),
            .volatile(0),
            .reset(0),
            .has_reset(1),
            .is_rand(1),
            .individually_accessible(0)
        );
    endfunction : build
endclass : apb_reg_1
`endif
