
xrt_au250_%: bd/%.tcl vivado.tcl
	rm -rf build/$*
	mkdir -p build
	cd build && \
	 vivado -nolog -nojournal -mode tcl \
	  -source ../vivado.tcl -tclargs $* $<

clean:
	rm -rf build
