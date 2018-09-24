`ifndef APB__WRITE__VERIFY__TEST__SV
`define APB__WRITE__VERIFY__TEST__SV
class apb_write_verify_test extends apb_base_test;
    `uvm_component_utils(apb_write_verify_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        apb_write_verify_seq m_seq_h;

        // Raise objection so the test will not end. Dropping it will end the test.
        phase.raise_objection(.obj(this));
        m_seq_h = apb_write_verify_seq::type_id::create(.name("m_seq_h"));
        assert(m_seq_h.randomize());
        `uvm_info(get_type_name(), {"\n", m_seq_h.sprint()}, UVM_LOW)

        // Set the generated sequence on the sequencer port of the agent.
        // The driver will pick up a transaction each and driver it.
        m_seq_h.start(m_env.m_apb_agent.apb_seqr);
        #10ns ;
        phase.drop_objection(.obj(this));
    endtask: run_phase
endclass: apb_write_verify_test
`endif
