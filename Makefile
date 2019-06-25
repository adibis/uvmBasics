help:
	@echo "Usage: make SIMULATOR TEST=test_name"
	@echo "  SIMULATOR can be 'vcs'."
	@echo "Example: make vcs TEST=apb_read_write_test"
	@echo "  Runs a simulation for apb_read_write_test using VCS."

# conditionals
#-------------------------------------------------------------------------------

ROOT := $(CURDIR)
export ROOT := $(CURDIR)
WORK_DIR := $(ROOT)/WORK_DIR

compile_files := -f $(ROOT)/regs/src/filelist.f
compile_files += -f $(ROOT)/agents/apb/src/filelist.f
compile_files += -f $(ROOT)/sequence_lib/src/filelist.f
compile_files += -f $(ROOT)/env/src/filelist.f
compile_files += -f $(ROOT)/tb/src/filelist.f
compile_files += -f $(ROOT)/src/filelist.f

compile_opts  :=
run_opts      := +UVM_TESTNAME=$(TEST)
top_module    := top

ifdef GUI
compile_opts  += -debug_access+r
run_opts      += -gui
endif

ifdef DEBUG
run_opts      += +UVM_VERBOSITY=UVM_DEBUG
endif

# constants
vcs_compile_opts := $(compile_opts) -timescale=1ns/10ps -ntb_opts uvm -sverilog
vcs_run_opts     := $(run_opts)

# targets
vcs: run_vcs

prep_vcs:

run_vcs:
	mkdir -p $(WORK_DIR) && \
	cd $(WORK_DIR) && \
	Vcs $(vcs_compile_opts) $(compile_files) && \
	./simv $(vcs_run_opts)

clean_vcs:
	rm -rf $(WORK_DIR)/*
