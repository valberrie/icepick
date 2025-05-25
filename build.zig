const std = @import("std");
const proj = @import("project.zig");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const tier0 = tier0: {
        const cpp = [_]proj.PlatformSrc{
            proj.PlatformSrc{ .data = &[_][]const u8{
                "assert_dialog.cpp",
                "commandline.cpp",
                "cpu.cpp",
                "cpumonitoring.cpp",
                "cpu_usage.cpp",
                "dbg.cpp",
                "dynfunction.cpp",
                "fasttimer.cpp",
                "mem.cpp",
                "mem_helpers.cpp",
                "memdbg.cpp",
                "memstd.cpp",
                "memvalidate.cpp",
                "minidump.cpp",
                "pch_tier0.cpp",
                "progressbar.cpp",
                "security.cpp",
                "systeminformation.cpp",
                "stacktools.cpp",
                "threadtools.cpp",
                "tier0_strtools.cpp",
                "tslist.cpp",
                "vprof.cpp",
                "../tier1/pathmatch.cpp",
            } },
            proj.PlatformSrc{
                .data = &[_][]const u8{
                    "PMELib.cpp",
                    "thread.cpp",
                    "cpu_posix.cpp",
                    "platform_posix.cpp",
                    "pme_posix.cpp",
                    "vcrmode_posix.cpp",
                },
                .spec = .{ .os = .{
                    .posix = null,
                } },
            },
            proj.PlatformSrc{
                .data = &[_][]const u8{
                    "PMELib.cpp",
                    "thread.cpp",
                    "assert_dialog.rc",
                    // "etwprof.cpp",
                    "platform.cpp",
                    "pme.cpp",
                    "vcrmode.cpp",
                    "win32consoleio.cpp",
                },
                .spec = .{
                    .os = .{ .windows = @as(void, undefined) },
                },
            },
        };

        const asm_att = [_]proj.PlatformSrc{proj.PlatformSrc{
            .data = &[_][]const u8{"InterlockedCompareExchange128.S"},
            .spec = .{
                .arch = .{ .amd64 = @as(void, undefined) },
            },
        }};

        const macros = [_]proj.PlatformMacros{proj.PlatformMacros{
            .data = &[_]proj.Macro{
                proj.Macro{ .name = "TIER0_DLL_EXPORT" },
            },
        }};

        break :tier0 proj.make_module(b, target, optimize, "tier0", .{ .use_sdl = true, .use_gl = true, .use_togles = true }, .shared, b.path("tier0"), &cpp, null, &asm_att, null, &macros, null, null);
    };

    const vstdlib = vstdlib: {
        const cpp = [_]proj.PlatformSrc{
            proj.PlatformSrc{ .data = &[_][]const u8{ "coroutine.cpp", "cvar.cpp", "jobthread.cpp", "KeyValuesSystem.cpp", "random.cpp", "vcover.cpp", "../public/tier0/memoverride.cpp" } },
            proj.PlatformSrc{
                .data = &[_][]const u8{"processutils.cpp"},
                .spec = .{
                    .os = .{ .windows = @as(void, undefined) },
                },
            },
        };

        const asm_att = [_]proj.PlatformSrc{proj.PlatformSrc{
            // TODO: at&t syntax
            .data = &[_][]const u8{ "coroutine_win64.masm", "GetStackPtr64.masm" },
            .spec = .{
                .os = .{ .windows = @as(void, undefined) },
                .arch = .{ .amd64 = @as(void, undefined) },
            },
        }};

        const macros = [_]proj.PlatformMacros{proj.PlatformMacros{
            .data = &[_]proj.Macro{
                proj.Macro{ .name = "VSTDLIB_DLL_EXPORT" },
            },
        }};

        const incpaths = [_]proj.PlatformIncludePaths{
            proj.PlatformIncludePaths{ .data = &[_]proj.Path{b.path("../public/vstdlib")} },
        };

        break :vstdlib proj.make_module(b, target, optimize, "vstdlib", .{ .use_sdl = true, .use_gl = true, .use_togles = true }, .shared, b.path("vstdlib"), &cpp, null, &asm_att, null, &macros, &incpaths, null);
    };

    b.installArtifact(vstdlib);
    b.installArtifact(tier0);
}
