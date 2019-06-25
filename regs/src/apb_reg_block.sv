`ifndef APB_REG_BLOCK__SV
`define APB_REG_BLOCK__SV
class apb_reg_block extends uvm_reg_block;
    `uvm_object_utils(apb_reg_block)

    rand apb_reg_0 m_apb_reg_0;
    rand apb_reg_1 m_apb_reg_1;
    uvm_reg_map m_reg_map;

    function new(string name = "apb_reg_block");
        super.new(
            .name(name),
            .has_coverage(UVM_NO_COVERAGE)
        );
    endfunction : new

    virtual function void build();
        m_apb_reg_0 = apb_reg_0::type_id::create("m_apb_reg_0");
        m_apb_reg_0.configure(.blk_parent(this));
        m_apb_reg_0.build();

        m_apb_reg_1 = apb_reg_1::type_id::create("m_apb_reg_1");
        m_apb_reg_1.configure(.blk_parent(this));
        m_apb_reg_1.build();

        m_reg_map = create_map(
            .name("m_reg_map"),
            .base_addr(8'h0),
            .n_bytes(2),
            .endian(UVM_LITTLE_ENDIAN)
        );

        m_reg_map.add_reg(
            .rg(m_apb_reg_0),
            .offset(8'h0),
            .rights("WO")
        );

        m_reg_map.add_reg(
            .rg(m_apb_reg_1),
            .offset(8'h1),
            .rights("RO")
        );

        lock_model();
    endfunction : build
endclass : apb_reg_block
`endif
