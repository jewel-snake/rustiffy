const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) !void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});
    //const top = b.step("run cargo", "");
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardOptimizeOption(.{});

    // Build the rust library, always
    const rustbuild = b.addSystemCommand(&[_][]const u8{
        "cargo",
        "build",
        "--release",
        "--manifest-path",
        "rust/Cargo.toml",
    });
    //try rustbuild.step.make();
    //top.dependOn(&rustbuild.step);

    const exe = b.addExecutable(.{ .name = "rustiffy", .root_source_file = .{ .path = "src/main.zig" } });
    //now target is set as attribute
    exe.target = target;
    //now optimization mode is set as attribute
    exe.optimize = mode;

    // Link to the rust library.
    // changed method name
    exe.addLibraryPath(.{ .path = "./rust/target/release" });
    exe.linkSystemLibrary("rust");

    // install() deprecated, use addInstallArtifact
    const run_cmd = b.addInstallArtifact(exe, .{});
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    // hooking all steps to top-level step
    run_step.dependOn(&rustbuild.step);
    run_step.dependOn(&run_cmd.step);
}
