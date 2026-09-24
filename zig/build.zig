const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .riscv64,
        .os_tag = .freestanding,
        .abi = .none,
        .cpu_model = .{
            .explicit = &std.Target.riscv.cpu.generic_rv64,
        },
    });

    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .ReleaseSmall,
    });

    const exe_module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .code_model = .medium,
        .link_libc = false,
        .stack_protector = false,
        .pic = false,
    });

    const exe = b.addExecutable(.{
        .name = "hello",
        .root_module = exe_module,
    });

    exe.setLinkerScript(b.path("linker.ld"));

    b.installArtifact(exe);

    const run_cmd = b.addSystemCommand(&.{
        "qemu-system-riscv64",
        "-machine",
        "virt",
        "-m",
        "128M",
        "-nographic",
        "-bios",
        "none",
        "-d",
        "int,cpu_reset,guest_errors",
        "-D",
        "qemu-debug.log",
        "-kernel",
    });

    run_cmd.addArtifactArg(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run in QEMU");
    run_step.dependOn(&run_cmd.step);

    const objdump_cmd = b.addSystemCommand(&.{
        "zig",
        "objdump",
        "-d",
    });
    objdump_cmd.addArtifactArg(exe);

    const objdump_step = b.step("objdump", "Disassemble ELF");
    objdump_step.dependOn(&objdump_cmd.step);

    const objcopy_cmd = b.addSystemCommand(&.{
        "zig",
        "objcopy",
        "-O",
        "binary",
    });

    objcopy_cmd.addArtifactArg(exe);
    objcopy_cmd.addArg("zig-out/bin/hello.bin");

    const bin_step = b.step("bin", "Convert ELF to raw binary");
    bin_step.dependOn(&objcopy_cmd.step);
}
