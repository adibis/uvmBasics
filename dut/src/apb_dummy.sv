// Class-based Verification
// APB_dummy.sv

// YOU DO NOT NEED TO MODIFY THIS FILE.

// Dummy APB slave module to act as a device-under-test for
// testbench lab exercises, reporting on the console all
// activity it sees on the APB bus so that you can easily
// see what your testbench did.

// This module merely reports bus activity to the console,
// and supplies dummy readback data that is the XOR of the
// most recently written data and the current read address.

module APB_dummy (
    input   bit   PCLK,
    input   bit   PRESET,
    input   logic PENABLE,
    input   logic PSEL,
    input   logic PWRITE,
    input   logic [15:0] PADDR,
    input   logic [15:0] PWDATA,
    output  logic [15:0] PRDATA,
    output  logic PERROR,
    output  logic PREADY
);

logic [15:0] memArray[128];
logic PREADY_NEXT;

// This code reports every active bus cycle to the console.
initial begin : cycle_reporting
    int clocks;
    for (int i = 0; i < 1024; i++) begin
        memArray[i] = 16'b0;
    end
    PREADY_NEXT = 0;
    PREADY = 0;
    PERROR = 1'b0;
    forever @(posedge PCLK) begin
        clocks++;
        PREADY <= 1'b0;
        if (PRESET) begin
            $display("Detected reset!");
        end else begin
            // Handle second cycle of the phase.
            if (PSEL && PENABLE && PWRITE && PREADY_NEXT) begin // it's a write
                $display("--------\nAPB write at clocks %0d/%0d, time=%0d:",
                    clocks-1, clocks, $time);
                $display("  A='h%h, D='h%h, ERROR='h%h", PADDR, PWDATA, PERROR);
                memArray[PADDR] <= PWDATA;
                PREADY_NEXT <= 1'b0;
                PREADY <= 1'b1;
            end else if (PSEL && PENABLE && !PWRITE && PREADY_NEXT) begin // it's a read
                // second clock of read, report it
                $display("--------\nAPB read at clocks %0d/%0d, time=%0d:",
                    clocks-1, clocks, $time);
                $display("  A='h%h, D='h%h, ERROR='h%h", PADDR, memArray[PADDR], PERROR);
                PRDATA <= memArray[PADDR];
                PREADY_NEXT <= 1'b0;
                PREADY <= 1'b1;
            end

            // Handle first cycle of the transfer.
            if (PSEL && !PENABLE) begin
                PREADY_NEXT<= $urandom_range(0,1);
            end

            // Handle wait cycle of the transfer.
            if (PSEL && PENABLE && !PREADY_NEXT) begin
                PREADY_NEXT<= $urandom_range(0,1);
            end

            //if ((PADDR > 128) && PSEL && PENABLE && PREADY_NEXT) begin
            //    PERROR = 1'b1;
            //end else begin
            //    PERROR = 1'b0;
            //end
        end // reset
    end
end : cycle_reporting

endmodule : APB_dummy
