`ifndef SCOREBOARD__SV
`define SCOREBOARD__SV
class chip_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(chip_scoreboard)

    uvm_analysis_imp#(apb_seq_item, chip_scoreboard) m_fifo;
    int error_count;
    bit [15:0] RAM_MODEL[int];

    function new(string name = "<anon>", uvm_component parent);
        super.new(name, parent);
        this.error_count = 0;
    endfunction: new

    function void build_phase( uvm_phase phase);
        super.build_phase(phase);
        m_fifo = new("m_fifo", this);
    endfunction : build_phase

    virtual function void write(apb_seq_item t);
        if (t.tr_error) begin
            `uvm_error(get_type_name(), "ERROR:: PERROR raised by the slave")
            error_count += 1;
        end else begin
            if(t.tr_rw == apb_seq_item::TR_READ) compare_data(t); // Compare.
            else begin
                if (t.tr_addr == 16'h0) begin
                    RAM_MODEL[0] = t.tr_wdata; // Write data to register.
                    RAM_MODEL[1] = (t.tr_wdata ^ 16'hFFFF); // Write data to register invert.
                end else begin
                    RAM_MODEL[t.tr_addr] = t.tr_wdata; // Write data to memory model.
                end
            end
        end
    endfunction : write

    virtual function void compare_data(apb_seq_item this_tr);
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

endclass : chip_scoreboard
`endif
