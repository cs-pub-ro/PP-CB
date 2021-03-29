run_shell:
	ghci -itable Main.hs
	
run_test:
	ghc -itable Main.hs -o Main
	mv Main tests
	python3 tests/tester.py
	rm -rf *.hi *.o
	rm -rf table/*.hi table/*.o
	rm -rf tests/Main
	
clean:
	rm -rf *.hi *.o
	rm -rf table/*.hi table/*.o
	rm -rf tests/Main
	rm -rf tests/output/*
