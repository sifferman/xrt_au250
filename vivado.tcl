
set project_name [lindex $argv 0]
set bd_tcl_filename [lindex $argv 1]

# start_gui

create_project au250 $project_name/ -part xcu250-figd2104-2L-e

# add_files -norecurse {}
# set_property file_type {Memory File} [get_files -all]

add_files -norecurse {
 ../axi_const_rd.v
}

# add_files -fileset constrs_1 -norecurse {}
# set_property PROCESSING_ORDER EARLY [get_files -of_objects [get_filesets constrs_1]]

# Block Design
create_bd_design "design_1"
source ../$bd_tcl_filename
save_bd_design
make_wrapper -files [get_files $project_name/au250.srcs/sources_1/bd/design_1/design_1.bd] -top -import

# Open IP Packaging Wizard
ipx::package_project -vendor ucsc.edu -library user -taxonomy /UserIP -import_files -set_current true -root_dir ./ip-$project_name

# Package for Vitis
set_property sdx_kernel true [ipx::current_core]
set_property sdx_kernel_type rtl [ipx::current_core]

# Package IP
ipx::save_core [ipx::current_core]

# Generate xo
package_xo \
  -force \
  -xo_path kernel-$project_name/kernel.xo \
  -kernel_name $project_name \
  -ctrl_protocol user_managed \
  -ip_directory ip-$project_name \
  -kernel_xml ../kernel.xml

exit
