// ---------- INFO ----------------------------------------------------------
// This test demonstrates use of constraints and also use of set_type_override
// to use user defined types instead of default types using the factory.
// --------------------------------------------------------------------------
`ifndef APB_RANDOM_READ_WRITE_OVERRIDE_TEST__SV
`define APB_RANDOM_READ_WRITE_OVERRIDE_TEST__SV
class apb_override_tr extends apb_seq_item;
    typedef enum bit [1:0] {RAM, ROM, IO} range_e;

    function new(string name = "<anon>");
        super.new(name);
    endfunction: new

    rand range_e range;

    constraint range_c {
        range dist {RAM:/ 80, IO:/20};
    }

    constraint addr_c {
        (range == RAM) -> tr_addr inside {[16'h0002:16'hAFFF]};
        (range == IO) -> tr_addr inside {[16'hFF00:16'hFFFF]};
    }

    `uvm_object_utils_begin(apb_override_tr)
        `uvm_field_enum(range_e, range, UVM_ALL_ON)
    `uvm_object_utils_end
endclass : apb_override_tr

class apb_random_read_write_override_test extends apb_base_test;
    `uvm_component_utils(apb_random_read_write_override_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Override the default apb_seq_item transaction and use the abp_override_tr
        // mentioned above.
        apb_seq_item::type_id::set_type_override(apb_override_tr::get_type());
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        apb_base_seq m_seq;

        m_seq = apb_base_seq::type_id::create(.name("m_seq"));
        // Raise objection so the test will not end. Dropping it will end the test.
        phase.raise_objection(.obj(this));
        repeat(20) begin
            assert(m_seq.randomize());
            m_seq.start(m_env.m_apb_agent.m_apb_seqr);
        end // repeat
        #10ns ;
        phase.drop_objection(.obj(this));
    endtask: run_phase
endclass: apb_random_read_write_override_test
`endif
