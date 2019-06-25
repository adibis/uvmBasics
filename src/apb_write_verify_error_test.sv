// ---------- INFO ----------------------------------------------------------
// This test demonstrates how to use configuration objects to change sequence
// behavior in the test.
// --------------------------------------------------------------------------
`ifndef APB_WRITE_VERIFY_ERROR_TEST__SV
`define APB_WRITE_VERIFY_ERROR_TEST__SV
class apb_write_verify_error_test extends apb_base_test;
    `uvm_component_utils(apb_write_verify_error_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        apb_write_verify_seq m_seq;

        // Raise objection so the test will not end. Dropping it will end the test.
        phase.raise_objection(.obj(this));
        m_seq = apb_write_verify_seq::type_id::create(.name("m_seq"));
        // Override the address constraints to generate out-of-bound addresses which should result in an error.
        m_apb_cfg.min_m_addr=16'h0080;
        m_apb_cfg.max_m_addr=16'h00f0;
        assert(m_seq.randomize());
        `uvm_info(get_type_name(), {"\n", m_seq.sprint()}, UVM_LOW)

        // Set the generated sequence on the sequencer port of the agent.
        // The driver will pick up a transaction each and driver it.
        m_seq.start(m_env.m_apb_agent.m_apb_seqr);
        #10ns ;
        phase.drop_objection(.obj(this));
    endtask: run_phase
endclass: apb_write_verify_error_test
`endif
