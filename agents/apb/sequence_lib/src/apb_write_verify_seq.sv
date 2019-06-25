// ---------- INFO ----------------------------------------------------------
// This is a sequence of sequences. Used to demonstrate how to create, start
// and constrain sequences from a parent sequence.
// --------------------------------------------------------------------------
`ifndef APB__WRITE__VERIFY__SEQ__SV
`define APB__WRITE__VERIFY__SEQ__SV
class apb_write_verify_seq extends uvm_sequence#(apb_seq_item);
    `uvm_object_utils(apb_write_verify_seq)

    apb_cfg m_apb_cfg;
    // Each sequence has a random number of transactions.
    // There is a constraint to keep the number reasonable.
    rand int unsigned num_of_tr;
    constraint num_of_tr_con {num_of_tr inside {[1:20]};}

    function new(string name = "<anon>");
        super.new(name);
    endfunction: new

    // This task generates a sequence of transactions.
    task body();
        apb_write_seq m_apb_write_seq;
        apb_read_seq m_apb_read_seq;
        repeat (num_of_tr) begin
            m_apb_write_seq = apb_write_seq::type_id::create(.name("m_apb_write_seq"));
            m_apb_read_seq = apb_read_seq::type_id::create(.name("m_apb_read_seq"));
            // Get the configuration object. Use that to constrain the address.
            // Note here that the UVM_SEQUENCE is not a uvm_component so we
            // need to get the sequencer for this sequence and then obtain the
            // configuration object.
            assert(uvm_config_db#(apb_cfg)::get(get_sequencer(), "", "apb_cfg", m_apb_cfg));
            `uvm_info(get_type_name(), $sformatf("Address range from configuration: [%h:%h]", m_apb_cfg.min_m_addr, m_apb_cfg.max_m_addr), UVM_DEBUG);
            assert(m_apb_write_seq.randomize() with {m_apb_write_seq.m_addr inside {[m_apb_cfg.min_m_addr:m_apb_cfg.max_m_addr]};});
            // Generate a read sequence with the same address as the write
            // sequence.
            assert(m_apb_read_seq.randomize() with {m_apb_read_seq.m_addr == m_apb_write_seq.m_addr;});
            m_apb_write_seq.start(m_sequencer);
            m_apb_read_seq.start(m_sequencer);
        end
    endtask: body
endclass: apb_write_verify_seq
`endif
