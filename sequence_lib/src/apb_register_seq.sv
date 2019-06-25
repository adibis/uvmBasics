`ifndef APB__REGISTER__SEQ__SV
`define APB__REGISTER__SEQ__SV
class apb_register_seq extends uvm_reg_sequence;
    `uvm_object_utils(apb_register_seq)

    rand logic [15:0]  m_wdata;
    logic [15:0]  m_rdata;

    function new(string name = "<anon>");
        super.new(name);
    endfunction: new

    // This task generates a single transaction.
    task body();
        apb_reg_block m_apb_reg_block;
        uvm_status_e status;

        assert($cast(m_apb_reg_block, model));

        write_reg(m_apb_reg_block.m_apb_reg_0, status, m_wdata);
        read_reg(m_apb_reg_block.m_apb_reg_1, status, m_rdata);
    endtask: body
endclass: apb_register_seq
`endif
