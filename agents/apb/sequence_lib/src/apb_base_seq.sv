`ifndef APB__BASE__SEQ__SV
`define APB__BASE__SEQ__SV
class apb_base_seq extends uvm_sequence#(APB_Tr);
    `uvm_object_utils(apb_base_seq)

    function new(string name = "<anon>");
        super.new(name);
    endfunction: new

    // This task generates a single transaction.
    task body();
        APB_Tr m_apb_tr;
        m_apb_tr = APB_Tr::type_id::create(.name("m_apb_tr"));
        start_item(m_apb_tr);
        // Generate a random transaction.
        assert(m_apb_tr.randomize());
        finish_item(m_apb_tr);
        // Housekeeping for easier debug during development.
        if (m_apb_tr.tr_rw == 0) begin
            `uvm_info (get_type_name(), $sformatf("READ:: RESPONSE:: Read Data = %h", m_apb_tr.tr_rdata), UVM_HIGH)
        end else begin
            `uvm_info (get_type_name(), "WRITE:: RESPONSE:: OK", UVM_HIGH)
        end
    endtask: body
endclass: apb_base_seq
`endif
