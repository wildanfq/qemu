ZIG := zig

TARGET := hello
ELF := $(TARGET).elf
BIN := $(TARGET).bin

CFLAGS := \
	-target riscv64-freestanding-none \
	-mcpu=generic_rv64+i+m+a+c \
	-mabi=lp64 \
	-mcmodel=medany \
	-O2 \
	-nostdlib \
	-ffreestanding \
	-fno-pie \
	-fno-stack-protector \
	-fno-asynchronous-unwind-tables \
	-fno-unwind-tables \
	-fno-sanitize=undefined

LDFLAGS := \
	-T linker.ld \
	-nostdlib \
	-no-pie

SOURCES := boot.S kernel.c

all: $(ELF)

$(ELF): $(SOURCES) linker.ld
	$(ZIG) cc $(CFLAGS) $(LDFLAGS) -o $@ $(SOURCES)

$(BIN): $(ELF)
	$(ZIG) objcopy -O binary $< $@

run: $(ELF)
	qemu-system-riscv64 \
		-machine virt \
		-m 128M \
		-nographic \
		-bios none \
		-kernel $<

bin: $(BIN)

dump: $(ELF)
	$(ZIG) objdump -d $<

headers: $(ELF)
	readelf -h -l $<

clean:
	rm -f $(ELF) $(BIN)

.PHONY: all run bin dump headers clean