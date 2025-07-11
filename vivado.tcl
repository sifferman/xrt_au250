
set project_name [lindex $argv 0]
set bd_tcl_filename [lindex $argv 1]

start_gui

create_project au250 $project_name/ -part xcu250-figd2104-2L-e

# add board files
set_param board.repoPaths [concat [get_param board.repoPaths] {
 ../au250_board_files_20200616/1.2
 ../au250_board_files_20200616/1.3
}]
set_property BOARD_PART xilinx.com:au250:part0:1.3 [current_project]

# add_files -norecurse {}
# set_property file_type {Memory File} [get_files -all]

add_files -norecurse {
 ../axi_const_rd.v
}

# add_files -fileset constrs_1 -norecurse {}
# set_property PROCESSING_ORDER EARLY [get_files -of_objects [get_filesets constrs_1]]

create_bd_design "design_1"
source ../$bd_tcl_filename
save_bd_design
make_wrapper -files [get_files $project_name/au250.srcs/sources_1/bd/design_1/design_1.bd] -top -import

load_features ipintegrator

ipx::package_project -taxonomy /UserIP -module design_1 -import_files -set_current true

s

set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY none [get_runs synth_1]
set_property STEPS.SYNTH_DESIGN.ARGS.DIRECTIVE PerformanceOptimized [get_runs synth_1]
launch_runs synth_1 -jobs [exec nproc]
wait_on_run synth_1

launch_runs impl_1 -to_step write_bitstream -jobs [exec nproc]
wait_on_run impl_1

# exit
