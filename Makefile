setup:
	git clone https://github.com/ewasm/scout.git

build:
	cargo +nightly build --manifest-path=client/Cargo.toml --release
	cargo +nightly build --manifest-path=scout/Cargo.toml --release

build-wasm:
	cargo +nightly build --lib --release --no-default-features --features=scout --target wasm32-unknown-unknown
	chisel run --config chisel.toml

scout: build build-wasm
	client/target/release/client package 2 1 --height=256 --scout > scout/sheth.yaml
	cp target/wasm32-unknown-unknown/release/sheth.wasm scout/sheth.wasm	
	scout/target/release/phase2-scout scout/sheth.yaml

test: build
	cargo +nightly build --bin binsheth --release
	client/target/release/client package 2 1 --height=256 > blob
	-target/release/binsheth blob
	rm blob
