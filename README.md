### Simple Network-on-Chip

This is an implementation of a simplistic but parametrizable Network-on-Chip with buffered sources, sinks and routers. The network was tested and functions correctly on Altera's DE1 and DE2 boards (using Altera Cyclone II 2C20 and Cyclone IV 4CE115 FPGAs respectively).

Each router has 5 serial-to-parallel converters, 5 parallel-to-serial, some switching logic and a fifo for storing packets. The project contains dummy sources and sinks that can inject/consume network traffic and perl scripts to generate verilog code from an abstract network description file (.arc).

The implementation was used to develop the dynamic thermal-aware routing strategies proposed in [1].

#### Example Topology

The diagram below shows a 4x4 network configuration for illustration. Routers have 5 duplex channel: east, west, north, south and local (not shown) and address/data lines to interface with an SRAM where their routing tables are stored.

![Screenshot](https://raw.github.com/gtarawneh/simpnoc/master/diagrams/diagram1.svg "Example Topology")

#### References

[1] Dahir N, Tarawneh G, Mak T, Al-Dujaily R, Yakovlev A. Design and Implementation of Dynamic Thermal-Adaptive Routing Strategy for Networks-on-Chip. In: Proceedings of Parallel, Distributed, and Network-Based Processing (PDP14). 2014.

