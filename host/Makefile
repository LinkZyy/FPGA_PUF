SHELL=/bin/bash
CXX=g++ -std=c++11
CXXFLAGS?=
CXXFLAGS+=-Wall -O0 -g
#XILINX_XRT=/opt/xilinx/xrt
#XILINX_VIVADO=/data/xilinx/Vivado/2021.2

#.PHONY:host
host:ENV
	$(CXX) -I$$(XILINX_XRT)/include/ -I$$(XILINX_VIVADO)/include/ $(CXXFLAGS) host.cpp  -o $@  -L$$(XILINX_XRT)/lib/ -lOpenCL -lpthread -lrt -lstdc++

.PHONY:hw-em
hw-em:ENV
	export XCL_EMULATION_MODE=hw_emu

.PHONY:ENV
ENV:
	@source /data/xilinx/Vitis/2021.2/settings64.sh
	@source /opt/xilinx/xrt/setup.sh
	@source /data/xilinx/Vitis_HLS/2021.2/settings64.sh
	@source /data/xilinx/Vivado/2021.2/settings64.sh

clean:
	rm ./*.o
