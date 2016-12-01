noc:
	@./create_noc.py 2>&1

topology:
	@mkdir -p gen
	@./create_topology.py

clean:
	@rm -rf gen
	@rm -rf build
	@rm -rf output
	@echo "Project directory cleaned"
