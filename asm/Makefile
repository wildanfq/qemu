CROSS   := riscv64-unknown-elf-

CC      := $(CROSS)gcc
OBJDUMP := $(CROSS)objdump
OBJCOPY := $(CROSS)objcopy
READELF := $(CROSS)readelf

TARGET  := hello
SRC     := hello.s
ELF     := $(TARGET).elf
BIN     := $(TARGET).bin

CFLAGS  := \
    -march=rv64imac \
    -mabi=lp64 \
    -mcmodel=medany \
    -nostdlib \
    -ffreestanding \
    -fno-pie \
    -g

LDFLAGS := \
    -T linker.ld \
    -nostdlib \
    -no-pie

all: $(ELF)

$(ELF): $(SRC) linker.ld
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(SRC)

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

run: $(ELF)
	qemu-system-riscv64 \
		-machine virt \
		-m 128M \
		-nographic \
		-bios none \
		-kernel $<

bin: $(BIN)

dump: $(ELF)
	$(OBJDUMP) -d $<

headers: $(ELF)
	$(READELF) -h -l $<

clean:
	rm -f $(ELF) $(BIN)

.PHONY: all run bin dump headers clean