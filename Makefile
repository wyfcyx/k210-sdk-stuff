mode = debug
target = riscv64gc-unknown-none-elf
proj ?= sdtest
elf = rust/target/$(target)/$(mode)/$(proj)
bin = $(elf).bin
port = /dev/ttyUSB0
elf:
ifeq ($(mode),release)
	cd rust/$(proj) && cargo build --$(mode)
else
	cd rust/$(proj) && cargo build
endif

bin: elf
	rust-objcopy $(elf) --strip-all -O binary $(bin)

run: bin
	python3 kflash.py -p $(port) -b 1500000 -t $(bin)
