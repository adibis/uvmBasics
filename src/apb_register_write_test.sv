// ---------- INFO ----------------------------------------------------------
// This test demonstrates how to start sequences from a test and use them.
// --------------------------------------------------------------------------
`ifndef APB_REGISTER_WRITE_TEST__SV
`define APB_REGISTER_WRITE_TEST__SV
class apb_register_write_test extends apb_base_test;
    `uvm_component_utils(apb_register_write_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        apb_register_seq m_seq;

        // Raise objection so the test will not end. Dropping it will end the test.
        phase.raise_objection(.obj(this));

        m_seq = apb_register_seq::type_id::create(.name("m_seq"));
        m_seq.model = m_apb_reg_block;
        assert(m_seq.randomize());
        `uvm_info(get_type_name(), {"\n", m_seq.sprint()}, UVM_LOW)

        // Set the generated sequence on the sequencer port of the agent.
        // The driver will pick up a transaction each and driver it.
        m_seq.start(m_env.m_apb_agent.m_apb_seqr);
        #10ns ;
        phase.drop_objection(.obj(this));
    endtask: run_phase
endclass: apb_register_write_test
`endif
