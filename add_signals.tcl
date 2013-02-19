set mylist [list]
lappend mylist "testbench.router0.myfifo1.count"
lappend mylist "testbench.router1.myfifo1.count"
lappend mylist "testbench.router2.myfifo1.count"
lappend mylist "testbench.router3.myfifo1.count"
lappend mylist "testbench.router4.myfifo1.count"
lappend mylist "testbench.router5.myfifo1.count"
lappend mylist "testbench.router6.myfifo1.count"
lappend mylist "testbench.router7.myfifo1.count"
lappend mylist "testbench.router8.myfifo1.count"
lappend mylist "testbench.router9.myfifo1.count"
lappend mylist "testbench.router10.myfifo1.count"
lappend mylist "testbench.router11.myfifo1.count"
lappend mylist "testbench.router12.myfifo1.count"
lappend mylist "testbench.router13.myfifo1.count"
lappend mylist "testbench.router14.myfifo1.count"
lappend mylist "testbench.router15.myfifo1.count"

lappend mylist "testbench.sink4.througput"
lappend mylist "testbench.sink8.througput"
lappend mylist "testbench.sink12.througput"

set num_added [ gtkwave::addSignalsFromList $mylist ]

