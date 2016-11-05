all:
	mkdir gen
	./create_topology.py && ./create_noc.py

clean:
	rm gen/*
