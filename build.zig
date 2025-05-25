const std = @import("std");
const proj = @import("project.zig");
const mods = @import("mods.zig");

const Compile = *std.Build.Step.Compile;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const common = proj.ModCommon{
        .b = b,
        .t = target,
        .o = optimize,
        .cfg = .{
            .use_sdl = true,
            .use_gl = true,
            .use_togles = true,
        },
    };

    const tier0 = proj.make_module(common, .{
        .name = "tier0",
        .kind = .shared,
        .root = b.path("tier0"),
        .src_cpp = &mods.tier0.cpp,
        .src_asm = &mods.tier0.asm_att,
        .macros = &mods.tier0.macros,
    });
    b.installArtifact(tier0);

    const tier1 = proj.make_module(common, .{
        .name = "tier1",
        .kind = .static,
        .root = b.path("tier1"),
        .src_cpp = &mods.tier1.cpp,
        .links = &mods.tier1.links,
        .macros = &mods.tier1.macros,
    });
    b.installArtifact(tier1);

    const vstdlib = proj.make_module(common, .{
        .name = "vstdlib",
        .kind = .shared,
        .root = b.path("vstdlib"),
        .src_cpp = &mods.vstdlib.cpp,
        .src_asm = &mods.vstdlib.asm_att,
        .macros = &mods.vstdlib.macros,
        .include_paths = &mods.vstdlib.incpaths,
        .depends_on = &[_]Compile{ tier0, tier1 },
    });
    b.installArtifact(vstdlib);

    const tier2 = proj.make_module(common, .{
        .name = "tier2",
        .kind = .static,
        .root = b.path("tier2"),
        .src_cpp = &mods.tier2.cpp,
        .include_paths = &mods.tier2.incpaths,
    });
    b.installArtifact(tier2);

    // TODO:
    // dmattributevar.h:1155:15: error: no member named 'Data' in 'CDmaElement<T>'
    // const tier3 = proj.make_module(common, .{
    //     .name = "tier3",
    //     .kind = .static,
    //     .root = b.path("tier3"),
    //     .src_cpp = &mods.tier3.cpp,
    //     .include_paths = &mods.tier3.incpaths,
    // });
    // b.installArtifact(tier3);

    const vpklib = proj.make_module(common, .{
        .name = "vpklib",
        .kind = .static,
        .root = b.path("vpklib"),
        .src_cpp = &mods.vpklib.cpp,
    });
    b.installArtifact(vpklib);

    const filesystem = proj.make_module(common, .{
        .name = "filesystem_stdio",
        .kind = .shared,
        .root = b.path("filesystem"),
        .src_cpp = &mods.filesystem.cpp,
        .macros = &mods.filesystem.macros,
        .depends_on = &[_]Compile{ tier0, tier1, tier2, vstdlib, vpklib },
    });
    b.installArtifact(filesystem);
}
