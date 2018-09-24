interface APB_If (input bit pclk);

  // APB synchronous signals defined here
  logic [15:0] paddr, pwdata, prdata;
  logic psel, penable, pwrite, perror, pready;

  // Clocking block to give access to all signals
  clocking master_cb @(posedge pclk);
    default input #1step output #1ns;
    input prdata, perror, pready;
    output paddr, pwdata, psel, penable, pwrite;
  endclocking : master_cb

  clocking slave_cb @(posedge pclk);
    default input #1step output #1ns;
    input prdata, perror, pready, paddr, pwdata, psel, penable, pwrite;
  endclocking : slave_cb

  modport master_mp (input pclk, prdata, perror, pready, output paddr, pwdata, psel, penable, pwrite);
  modport slave_mp (input pclk, paddr, pwdata, psel, penable, pwrite, output prdata, perror, pready);
  modport master_sync_mp (clocking master_cb);
  modport slave_sync_mp (clocking slave_cb);

endinterface : APB_If
