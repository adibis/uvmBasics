class APB_Scoreboard extends uvm_scoreboard;
    `uvm_component_utils(APB_Scoreboard)

    uvm_analysis_imp#(APB_Tr, APB_Scoreboard) m_fifo_h;
    int error_count;
    logic [15:0] RAM_MODEL[int];

    function new(string name = "<anon>", uvm_component parent);
        super.new(name, parent);
        this.error_count = 0;
    endfunction: new

    function void build_phase( uvm_phase phase);
        super.build_phase(phase);
        m_fifo_h = new("m_fifo_h", this);
    endfunction : build_phase

    virtual function void write(APB_Tr t);
        if(t.tr_rw == APB_Tr::TR_READ) compare_data(t); // Compare.
        else RAM_MODEL[t.tr_addr] = t.tr_wdata; // Write data to memory model.
    endfunction : write

    virtual function void compare_data(APB_Tr this_tr);
        `uvm_info(get_type_name(), $sformatf("Checking Read Value: ADDR: %h, PRDATA: %h, EXPECTED: %h",
            this_tr.tr_addr, this_tr.tr_rdata, RAM_MODEL[this_tr.tr_addr]), UVM_NONE)
        if (this_tr.tr_rdata !== RAM_MODEL[this_tr.tr_addr]) begin
            `uvm_error(get_type_name(), "ERROR:: Data mismatch")
            error_count += 1;
        end else begin
            `uvm_info(get_type_name(), "SUCCESS: Data match", UVM_NONE)
        end
    endfunction : compare_data

    function void report();
        if(error_count) begin
            `uvm_error(get_type_name(), "---------- SIMULATION FAILED ----------")
        end else begin
            `uvm_info(get_type_name(), "---------- SIMULATION PASSED ----------", UVM_NONE)
        end
        `uvm_info(get_type_name(), $sformatf("Error_Count = %h", this.error_count), UVM_NONE)
    endfunction : report

endclass : APB_Scoreboard
