`ifndef APB__READ__SEQ__SV
`define APB__READ__SEQ__SV
class apb_read_seq extends uvm_sequence#(apb_seq_item);
    `uvm_object_utils(apb_read_seq)

    rand logic [15:0]  m_addr;

    function new(string name = "<anon>");
        super.new(name);
    endfunction: new

    // This task generates a single transaction.
    task body();
        apb_seq_item m_apb_seq_item;
        m_apb_seq_item = apb_seq_item::type_id::create(.name("m_apb_seq_item"));
        start_item(m_apb_seq_item);
        // Generate a read transaction.
        assert(m_apb_seq_item.randomize() with {m_apb_seq_item.tr_rw == apb_seq_item::TR_READ; m_apb_seq_item.tr_addr == this.m_addr;});
        finish_item(m_apb_seq_item);
        // Housekeeping for easier debug during development.
        `uvm_info (get_type_name(), $sformatf("READ:: RESPONSE:: Read Data = %h", m_apb_seq_item.tr_rdata), UVM_HIGH)
    endtask: body
endclass: apb_read_seq
`endif
