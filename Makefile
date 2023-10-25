
DUNE_OPTS?=
build:
	dune build @install $(DUNE_OPTS)

clean:
	@dune clean

test:
	@dune runtest $(DUNE_OPTS)

doc:
	@dune build $(DUNE_OPTS) @doc

build-dev:
	dune build @install @runtest $(DUNE_OPTS) --workspace=dune-workspace.dev

WATCH?= @check @runtest
watch:
	dune build $(DUNE_OPTS) -w $(WATCH)

.PHONY: test clean

VERSION=$(shell awk '/^version:/ {print $$2}' moonpool.opam)
update_next_tag:
	@echo "update version to $(VERSION)..."
	sed -i "s/NEXT_RELEASE/$(VERSION)/g" $(wildcard src/*.ml) $(wildcard src/**/*.ml) $(wildcard src/*.mli) $(wildcard src/**/*.mli)
