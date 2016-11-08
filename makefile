all:
	@mkdir -p gen
	@./create_topology.py && ./create_noc.py 2>&1 | ./beautify.py

clean:
	@rm -rf gen
	@rm -rf build
	@rm -rf output
	@echo "Project directory cleaned"
