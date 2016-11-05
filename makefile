all:
	@mkdir gen
	@./create_topology.py && ./create_noc.py

clean:
	@rm -rf gen
	@rm -rf build
	@rm -rf output
	@echo "Project directory cleaned"
