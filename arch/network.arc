# Network architecture file
#
# This file defines network topology. Each lines denotes a connection
# between two elements.
#
# Empty lines and those starting with # are ignored.
#
# connection line formats:
#
# 1) Router to Router Connection: rr,R1,R2,P1,P2
#    R1 = router1 id, R2 = router2 id, P1 = router1 port, P2 = router2 port
#
# 2) Source to Router Connection: sr,S,R,P
#    S = source id, R = router id, P = router port
#
# 3) Router to Sink Connection: rs,R,P,S
#    R = router id, P = router port, S = sink id
#
# 4) TX terminator: tx,R,P
#    R = router id, P = router port
#
# 5) RX terminator: rx,R,P
#    R = router id, P = router port
#
# port codes: N(0), S(1), E(2), W(3), L(4)

#sr,0,0,0
#sr,1,0,1
#sr,2,0,2
#sr,3,0,3
#rs,0,0,0

sr,0,0,2
rr,0,1,4,3
rr,1,2,4,1
rs,2,4,0


