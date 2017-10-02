
all:
	@echo "compiling spinal-lib-is-sim..."
	@python	scripts/make.py
	@echo "\n\033[0;32m[OK] Compiling spinal-lib-is-sim : Done\033[m\n"

clean:
	@! test -e gen || rm -rf gen/ .gen/ models.js processes.js stylesheets.css index.js
	@echo "\033[0;32m[OK] cleaning spinal-lib-is-sim : Done\033[m"

.PHONY: all clean
