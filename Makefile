ly-file?="main.ly"
# also can be "langely-examples/random_generator.ly"

clean:
	rm -r _build
	rm main.native

build:
	ocamlbuild -use-menhir src/main.native

run: build
	cat ${ly-file} | ./main.native

.PHONY: clean build run
