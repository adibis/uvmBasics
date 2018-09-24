`ifndef APB__READ__SEQ__SV
`define APB__READ__SEQ__SV
class apb_read_seq extends uvm_sequence#(APB_Tr);
    `uvm_object_utils(apb_read_seq)

    rand logic [15:0]  m_addr;

    function new(string name = "<anon>");
        super.new(name);
    endfunction: new

    // This task generates a single transaction.
    task body();
        APB_Tr m_apb_tr;
        m_apb_tr = APB_Tr::type_id::create(.name("m_apb_tr"));
        start_item(m_apb_tr);
        // Generate a read transaction.
        assert(m_apb_tr.randomize() with {m_apb_tr.tr_rw == APB_Tr::TR_READ; m_apb_tr.tr_addr == this.m_addr;});
        finish_item(m_apb_tr);
        // Housekeeping for easier debug during development.
        `uvm_info (get_type_name(), $sformatf("READ:: RESPONSE:: Read Data = %h", m_apb_tr.tr_rdata), UVM_HIGH)
    endtask: body
endclass: apb_read_seq
`endif
