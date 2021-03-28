run_shell:
	ghci -itable main.hs
	
run_test:
	ghc -itable main.hs -o main
	mv main tests
	python3 tests/tester.py
	rm -rf *.hi *.o
	rm -rf table/*.hi table/*.o
	rm -rf tests/main
clean:
	rm -rf *.hi *.o
	rm -rf table/*.hi table/*.o
	rm -rf tests/main
	rm -rf tests/output/*
