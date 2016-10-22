#!/bin/python

def main():
    w = 4
    h = 4
    for (x,y) in [(x,y) for y in range(h) for x in range(w-1)]:
        r1 = getRouterID(x, y)
        r2 = getRouterID(x+1, y)
        print("# horizontal channels between routers %d and %d" % (r1, r2)) 
        print("rr,%d,%d,2,3" % (r1, r2))
        print("rr,%d,%d,3,2" % (r2, r1))
    for (x,y) in [(x,y) for y in range(h-1) for x in range(w)]: 
        r1 = getRouterID(x, y)
        r2 = getRouterID(x, y+1)
        print("# vertical channels between routers %d and %d" % (r1, r2)) 
        print("rr,%d,%d,1,0" % (r1, r2))
        print("rr,%d,%d,0,1" % (r2, r1))
    for x in range(w):
        r1 = getRouterID(x, 0)
        print("# north terminator")
        print("tx,%d,0" % r1)
        print("rx,%d,0" % r1)
        r2 = getRouterID(x, h-1)
        print("# south terminator")
        print("tx,%d,1" % r2)
        print("rx,%d,1" % r2)
    for y in range(h):
        r1 = getRouterID(0, y)
        print("# west terminator")
        print("tx,%d,3" % r1)
        print("rx,%d,3" % r1)
        r2 = getRouterID(w-1, y)
        print("# east terminator")
        print("tx,%d,2" % r2)
        print("rx,%d,2" % r2)
    for i in range(h*w):
        print("# source")
        print("sr,%d,%d,4" % (i,i))
        print("# sink")
        print("rs,%d,4,%d" % (i,i))

def getRouterID(x, y):
    return 4 * y + x

main()

