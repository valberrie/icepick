const std = @import("std");
const proj = @import("project.zig");

pub const tier0 = struct {
    pub const cpp = [_]proj.PlatformSrc{
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

    pub const asm_att = [_]proj.PlatformSrc{proj.PlatformSrc{
        .data = &[_][]const u8{"InterlockedCompareExchange128.S"},
        .spec = .{
            .arch = .{ .amd64 = @as(void, undefined) },
        },
    }};

    pub const macros = [_]proj.PlatformMacros{proj.PlatformMacros{
        .data = &[_]proj.Macro{
            proj.Macro{ .name = "TIER0_DLL_EXPORT" },
        },
    }};
};

pub const tier1 = struct {
    pub const cpp = [_]proj.PlatformSrc{
        proj.PlatformSrc{
            .data = &[_][]const u8{
                "../utils/lzma/C/LzmaDec.c",
                "bitbuf.cpp",
                "byteswap.cpp",
                "characterset.cpp",
                "checksum_crc.cpp",
                "checksum_md5.cpp",
                "checksum_sha1.cpp",
                "commandbuffer.cpp",
                "convar.cpp",
                "datamanager.cpp",
                "diff.cpp",
                "generichash.cpp",
                "ilocalize.cpp",
                "interface.cpp",
                "KeyValues.cpp",
                "keyvaluesjson.cpp",
                "kvpacker.cpp",
                "lzmaDecoder.cpp",
                "lzss.cpp", // [!$SOURCESDK]
                "mempool.cpp",
                "memstack.cpp",
                "NetAdr.cpp",
                "newbitbuf.cpp",
                "rangecheckedvar.cpp",
                "reliabletimer.cpp",
                "snappy-sinksource.cpp",
                "snappy-stubs-internal.cpp",
                "snappy.cpp",
                "sparsematrix.cpp",
                "splitstring.cpp",
                "stringpool.cpp",
                "strtools.cpp",
                "strtools_unicode.cpp",
                "tier1.cpp",
                "tokenreader.cpp",
                "uniqueid.cpp",
                "utlbinaryblock.cpp",
                "utlbuffer.cpp",
                "utlbufferutil.cpp",
                "utlstring.cpp",
                "utlsymbol.cpp",
            },
        },
        proj.PlatformSrc{
            .data = &[_][]const u8{
                // "pathmatch.cpp"
                "processor_detect_linux.cpp",
                "qsort_s.cpp",
            },
            .spec = .{ .os = .{
                .posix = null,
            } },
        },
        proj.PlatformSrc{
            .data = &[_][]const u8{"processor_detect.cpp"},
            .spec = .{
                .os = .{ .windows = @as(void, undefined) },
            },
        },
    };

    pub const links = [_]proj.PlatformLink{
        proj.PlatformLink{ .data = &[_][]const u8{"iconv"}, .spec = .{ .os = proj.Os.DARWIN } },
    };

    pub const macros = [_]proj.PlatformMacros{proj.PlatformMacros{
        .data = &[_]proj.Macro{
            proj.Macro{ .name = "TIER1_STATIC_LIB", .val = "1" },
        },
    }};
};

pub const vstdlib = struct {
    pub const cpp = [_]proj.PlatformSrc{
        proj.PlatformSrc{ .data = &[_][]const u8{ "coroutine.cpp", "cvar.cpp", "jobthread.cpp", "KeyValuesSystem.cpp", "random.cpp", "vcover.cpp", "../public/tier0/memoverride.cpp" } },
        proj.PlatformSrc{
            .data = &[_][]const u8{"processutils.cpp"},
            .spec = .{
                .os = .{ .windows = @as(void, undefined) },
            },
        },
    };

    pub const asm_att = [_]proj.PlatformSrc{proj.PlatformSrc{
        // TODO: at&t syntax
        .data = &[_][]const u8{ "coroutine_win64.masm", "GetStackPtr64.masm" },
        .spec = .{
            .os = .{ .windows = @as(void, undefined) },
            .arch = .{ .amd64 = @as(void, undefined) },
        },
    }};

    pub const macros = [_]proj.PlatformMacros{proj.PlatformMacros{
        .data = &[_]proj.Macro{
            proj.Macro{ .name = "VSTDLIB_DLL_EXPORT" },
        },
    }};

    pub const incpaths = [_]proj.PlatformIncludePaths{
        proj.PlatformIncludePaths{ .data = &[_][]const u8{"../public/vstdlib"} },
    };
};

pub const tier2 = struct {
    pub const cpp = [_]proj.PlatformSrc{
        proj.PlatformSrc{
            .data = &[_][]const u8{
                "beamsegdraw.cpp",
                "defaultfilesystem.cpp",
                "dmconnect.cpp",
                "fileutils.cpp",
                "keybindings.cpp",
                "../public/map_utils.cpp",
                "../public/materialsystem/MaterialSystemUtil.cpp",
                "camerautils.cpp",
                "meshutils.cpp",
                "p4helpers.cpp",
                "renderutils.cpp",
                "riff.cpp",
                "soundutils.cpp",
                "tier2.cpp",
                "util_init.cpp",
                "utlstreambuffer.cpp",
                "vconfig.cpp",
                "keyvaluesmacros.cpp",
            },
        },
    };

    pub const incpaths = [_]proj.PlatformIncludePaths{
        proj.PlatformIncludePaths{ .data = &[_][]const u8{"../public/tier2"} },
    };
};

pub const tier3 = struct {
    pub const cpp = [_]proj.PlatformSrc{
        proj.PlatformSrc{
            .data = &[_][]const u8{
                "tier3.cpp",
                "mdlutils.cpp",
                "choreoutils.cpp",
                "scenetokenprocessor.cpp",
                "studiohdrstub.cpp",
            },
        },
    };

    pub const incpaths = [_]proj.PlatformIncludePaths{
        proj.PlatformIncludePaths{ .data = &[_][]const u8{ "../public/tier2", "../public/tier3" } },
    };
};

pub const vpklib = struct {
    pub const cpp = [_]proj.PlatformSrc{
        proj.PlatformSrc{
            .data = &[_][]const u8{
                "packedstore.cpp",
                "../common/simplebitstring.cpp",
            },
        },
    };
};

pub const filesystem = struct {
    pub const cpp = [_]proj.PlatformSrc{
        proj.PlatformSrc{
            .data = &[_][]const u8{
                "basefilesystem.cpp",
                "packfile.cpp",
                "filetracker.cpp",
                "filesystem_async.cpp",
                "filesystem_stdio.cpp",
                "../public/kevvaluescompiler.cpp",
                "../public/zip_utils.cpp",
                "QueuedLoader.cpp",
                "../public/tier0/memoverride.cpp",
            },
        },
        proj.PlatformSrc{
            .data = &[_][]const u8{
                "linux_support.cpp",
            },
            .spec = .{ .os = .{
                .posix = null,
            } },
        },
    };

    pub const macros = [_]proj.PlatformMacros{proj.PlatformMacros{
        .data = &[_]proj.Macro{
            proj.Macro{ .name = "FILESYSTEM_STDIO_EXPORTS", .val = "1" },
            proj.Macro{ .name = "DONT_PROTECT_FILEIO_FUNCTIONS", .val = "1" },
            proj.Macro{ .name = "SUPPORT_PACKED_STORE", .val = "1" },
            // proj.Macro{ .name = "PROTECTED_THINGS_ENABLE", .val = "1" },
            // proj.Macro{ .name = "_USE_32BIT_TIME_T", .val = "1" },
        },
    }};
};
