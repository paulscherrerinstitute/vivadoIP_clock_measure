

#false path constraint for asynchronous registers
set_false_path -to [get_cells -hierarchical -filter {NAME =~ *async_fd_inst && IS_SEQUENTIAL}]

