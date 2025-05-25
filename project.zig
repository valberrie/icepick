const std = @import("std");

pub const Macro = struct { name: []const u8, val: []const u8 = "" };
pub const Path = std.Build.LazyPath;

pub const Os = union(enum) {
    posix: ?union(enum) {
        other: ?std.Target.Os.Tag,
        linux: void,
        android: void,
        bsd: ?union(enum) {
            other: ?std.Target.Os.Tag,
            darwin: void,
        },
    },
    windows: void,

    // TODO: android
    pub fn from(f: std.Target.Os.Tag) Os {
        return switch (f) {
            .linux => Os{ .posix = .{ .linux = @as(void, undefined) } },
            .windows => Os{ .windows = @as(void, undefined) },
            .netbsd, .openbsd, .freebsd, .dragonfly => Os{ .posix = .{ .bsd = .{ .other = f } } },
            .macos => Os{ .posix = .{ .bsd = .{ .darwin = @as(void, undefined) } } },
            else => unreachable,
        };
    }

    pub fn filtered(this: Os, other: Os) bool {
        return switch (this) {
            .windows => switch (other) {
                .windows => true,
                else => false,
            },
            .posix => |p0| switch (other) {
                // .release => |r1| if (r1 == null or r0 == null) true else (r0.? == r1.?),
                .posix => |p1| if (p0 == null or p1 == null) true else switch (p0.?) {
                    .linux => if (p1.? == .linux) true else false,
                    .android => if (p1.? == .android) true else false,
                    .bsd => |b0| if (b0 == null or p1.?.bsd == null) true else switch (p1.?.bsd.?) {
                        .darwin => if (b0.? == .darwin) true else false,
                        .other => |o0| if (o0 == null or p1.?.other == null) true else if (p1.? == .other and p1.?.other == o0.?) true else false,
                    },
                    .other => |o0| if (o0 == null or p1.?.other == null) true else if (p1.? == .other and p1.?.other == o0.?) true else false,
                },
                else => false,
            },
        };
    }

    // TODO: more
    pub const DARWIN = Os{ .posix = .{ .bsd = .{ .darwin = @as(void, undefined) } } };
};

pub const Arch = union(enum) {
    amd64: void,
    i386: void,

    pub fn filtered(this: Arch, other: Arch) bool {
        return switch (this) {
            .amd64 => (other == .amd64),
            .i386 => (other == .i386),
        };
    }

    pub fn from(f: std.Target.Cpu.Arch) Arch {
        return switch (f) {
            .x86_64 => Arch{ .amd64 = @as(void, undefined) },
            .x86 => Arch{ .i386 = @as(void, undefined) },
            else => unreachable,
        };
    }
};

pub const Mode = union(enum) {
    release: ?std.builtin.OptimizeMode,
    debug: void,

    pub fn filtered(this: Mode, other: Mode) bool {
        return switch (this) {
            .debug => switch (other) {
                .debug => true,
                else => false,
            },
            .release => |r0| switch (other) {
                .debug => false,
                .release => |r1| if (r1 == null or r0 == null) true else (r0.? == r1.?),
            },
        };
    }

    pub fn from(f: std.builtin.OptimizeMode) Mode {
        return switch (f) {
            .Debug => Mode{ .debug = @as(void, undefined) },
            else => Mode{ .release = f },
        };
    }
};

pub const Api = union(enum) {
    sdl: void,
    gl: void,
    togles: void,

    pub fn filtered(this: Api, other: Api) bool {
        return switch (this) {
            .sdl => switch (other) {
                .sdl => true,
                else => false,
            },
            .gl => switch (other) {
                .gl => true,
                else => false,
            },
            .togles => switch (other) {
                .togles => true,
                else => false,
            },
        };
    }

    // TODO
    // pub fn from(from: Config) Api {

    // }
};

pub const Spec = struct {
    os: ?Os = null,
    arch: ?Arch = null,
    mode: ?Mode = null,
    api: ?Api = null,

    pub fn from(t: std.Build.ResolvedTarget, o: std.builtin.OptimizeMode) Spec {
        return Spec{
            .os = Os.from(t.result.os.tag),
            .arch = Arch.from(t.result.cpu.arch),
            .mode = Mode.from(o),
            .api = null,
        };
    }

    pub fn filtered(this: Spec, other: Spec) bool {
        const os_match = if (this.os == null or other.os == null) true else this.os.?.filtered(other.os.?);
        const arch_match = if (this.arch == null or other.arch == null) true else this.arch.?.filtered(other.arch.?);
        const mode_match = if (this.mode == null or other.mode == null) true else this.mode.?.filtered(other.mode.?);
        const api_match = if (this.api == null or other.api == null) true else this.api.?.filtered(other.api.?);
        return os_match and arch_match and mode_match and api_match;
    }
};

pub const PlatformSrc = struct { data: []const []const u8, spec: ?Spec = null };
pub const PlatformLink = struct { data: []const []const u8, spec: ?Spec = null };
pub const PlatformCflags = struct { data: []const []const u8, spec: ?Spec = null };
pub const PlatformMacros = struct { data: []const Macro, spec: ?Spec = null };
pub const PlatformIncludePaths = struct { data: []const []const u8, spec: ?Spec = null };
pub const PlatformLinkPaths = struct { data: []const []const u8, spec: ?Spec = null };

pub const Config = struct {
    use_sdl: bool,
    use_gl: bool,
    use_togles: bool,
};

pub const ModType = enum {
    static,
    shared,
    exe,
};

pub const ModCommon = struct {
    b: *std.Build,
    t: std.Build.ResolvedTarget,
    o: std.builtin.OptimizeMode,
    cfg: struct {
        use_sdl: bool,
        use_gl: bool,
        use_togles: bool,
    },
};

pub const ModInfo = struct {
    name: []const u8,
    kind: ModType,
    root: ?Path = null,
    src_cpp: []const PlatformSrc,
    src_asm: ?[]const PlatformSrc = null,
    flags: ?[]const PlatformCflags = null,
    links: ?[]const PlatformLink = null,
    macros: ?[]const PlatformMacros = null,
    include_paths: ?[]const PlatformIncludePaths = null,
    link_paths: ?[]const PlatformLinkPaths = null,
    depends_on: ?[]const *std.Build.Step.Compile = null,
};

pub fn make_module(common: ModCommon, info: ModInfo) *std.Build.Step.Compile {
    const b = common.b;
    const t = common.t;
    const o = common.o;
    // const cfg = common.cfg;

    const IPATH = [_]PlatformIncludePaths{
        PlatformIncludePaths{ .data = &[_][]const u8{
            ".",
            "../thirdparty",
            "../",
            "../public",
            "../public/tier0",
            "../public/tier1",
            "../common",
        } },
        PlatformIncludePaths{ .data = &[_][]const u8{"../thirdparty/SDL"}, .spec = .{ .api = .{ .sdl = @as(void, undefined) } } },
    };

    const LPATH = [_]PlatformLinkPaths{
        PlatformLinkPaths{
            .data = &[_][]const u8{"../thirdparty"},
        },
    };

    const LINK = [_]PlatformLink{ PlatformLink{ .data = &[_][]const u8{ "dl", "bz2", "rt", "m" }, .spec = .{ .os = .{
        .posix = null,
    } } }, PlatformLink{ .data = &[_][]const u8{
        "user32",
        "shell32",
        "gdi32",
        "advapi32",
        "dbghelp",
        "psapi",
        "ws2_32",
        "rpcrt4",
        "winmm",
        "wininet",
        "ole32",
        "shlwapi",
        "imm32",
    }, .spec = .{ .os = .{ .windows = @as(void, undefined) } } } };
    // TODO: darwin links

    const MACROS = [_]PlatformMacros{
        PlatformMacros{ .data = &[_]Macro{
            Macro{ .name = "GIT_COMMIT_HASH" },
        } },
        PlatformMacros{
            .data = &[_]Macro{
                Macro{ .name = "DEBUG" },
                // Macro{ .name = "_DEBUG" },
            },
            .spec = .{
                .mode = .{ .debug = @as(void, undefined) },
            },
        },
        PlatformMacros{ .data = &[_]Macro{
            Macro{ .name = "NDEBUG" },
        }, .spec = .{
            .mode = .{ .release = null },
        } },
        PlatformMacros{
            .data = &[_]Macro{
                Macro{ .name = "POSIX", .val = "1" },
                Macro{ .name = "_POSIX", .val = "1" },
                Macro{ .name = "PLATFORM_POSIX", .val = "1" },
                Macro{ .name = "GNUC", .val = "1" },
                Macro{ .name = "NO_MEMOVERRIDE_NEW_DELETE", .val = "1" },
                // for darwin
                Macro{ .name = "_DLL_EXT", .val = t.result.os.tag.dynamicLibSuffix() },
            },
            .spec = .{
                .os = .{ .posix = null },
            },
        },
        PlatformMacros{ .data = &[_]Macro{
            Macro{ .name = "LINUX", .val = "1" },
            Macro{ .name = "_LINUX", .val = "1" },
            Macro{ .name = "NO_HOOK_MALLOC", .val = "1" },
        }, .spec = .{
            .os = .{ .posix = .{ .linux = @as(void, undefined) } },
        } },
        PlatformMacros{ .data = &[_]Macro{
            Macro{ .name = "PLATFORM_BSD", .val = "1" },
        }, .spec = .{
            .os = .{ .posix = .{ .bsd = null } },
        } },
        PlatformMacros{ .data = &[_]Macro{
            Macro{ .name = "OSX", .val = "1" },
            Macro{ .name = "_OSX", .val = "1" },
            Macro{
                .name = "NO_HOOK_MALLOC",
            },
        }, .spec = .{
            .os = .{ .posix = .{ .bsd = .{ .darwin = @as(void, undefined) } } },
        } },
        PlatformMacros{
            .data = &[_]Macro{
                Macro{ .name = "WIN32", .val = "1" },
                Macro{ .name = "_WIN32", .val = "1" },
                Macro{
                    .name = "_WINDOWS",
                },
                Macro{
                    .name = "_CRT_SECURE_NO_DEPRECATE",
                },
                Macro{
                    .name = "_CRT_NONSTDC_NO_DEPRECATE",
                },
                Macro{
                    .name = "_ALLOW_RUNTIME_LIBRARY_MISMATCH",
                },
                Macro{
                    .name = "_ALLOW_ITERATOR_DEBUG_LEVEL_MISMATCH",
                },
                Macro{
                    .name = "_ALLOW_MSC_VER_MISMATCH",
                },
                Macro{
                    .name = "NO_X360_XDK",
                },
                Macro{ .name = "_DLL_EXT", .val = ".dll" },
            },
            .spec = .{
                .os = .{ .windows = @as(void, undefined) },
            },
        },
        PlatformMacros{ .data = &[_]Macro{
            Macro{ .name = "PLATFORM_64BITS", .val = "1" },
        }, .spec = .{
            .arch = .{ .amd64 = @as(void, undefined) },
        } },
        PlatformMacros{ .data = &[_]Macro{
            Macro{ .name = "USE_SDL", .val = "1" },
        }, .spec = .{
            .api = .{ .sdl = @as(void, undefined) },
        } },
        PlatformMacros{ .data = &[_]Macro{
            Macro{
                .name = "DX_TO_GL_ABSTRACTION",
            },
            Macro{
                .name = "GL_GLEXT_PROTOTYPES",
            },
            Macro{
                .name = "BINK_VIDEO",
            },
        }, .spec = .{
            .api = .{ .gl = @as(void, undefined) },
        } },
        PlatformMacros{ .data = &[_]Macro{Macro{ .name = "TOGLES" }}, .spec = .{
            .api = .{ .togles = @as(void, undefined) },
        } },
    };

    const FLAGS = [_]PlatformCflags{
        PlatformCflags{
            .data = &[_][]const u8{
                "-std=c++11",
                "-fpermissive",
            },
        },
        PlatformCflags{ .data = &[_][]const u8{ "-Og", "-ggdb" }, .spec = .{
            .mode = .{ .debug = @as(void, undefined) },
        } },
        PlatformCflags{ .data = &[_][]const u8{
            "-Ofast",
        }, .spec = .{
            .mode = .{ .release = .ReleaseFast },
        } },
        PlatformCflags{ .data = &[_][]const u8{
            "-O3",
        }, .spec = .{
            .mode = .{ .release = .ReleaseSafe },
        } },
        PlatformCflags{ .data = &[_][]const u8{
            "-Os",
        }, .spec = .{
            .mode = .{ .release = .ReleaseSmall },
        } },
    };

    const root = if (info.root) |r| r else b.path(".");

    var cxxsrc = std.ArrayList([]const u8).init(b.allocator);
    var asmsrc = std.ArrayList([]const u8).init(b.allocator);
    var cflags = std.ArrayList([]const u8).init(b.allocator);
    var macros = std.ArrayList(Macro).init(b.allocator);
    var links = std.ArrayList([]const u8).init(b.allocator);
    var ipaths = std.ArrayList([]const u8).init(b.allocator);
    var lpaths = std.ArrayList([]const u8).init(b.allocator);

    defer {
        macros.deinit();
        links.deinit();
        cxxsrc.deinit();
        asmsrc.deinit();
        cflags.deinit();
        lpaths.deinit();
        ipaths.deinit();
    }

    const spec = Spec.from(t, o);

    const fns = struct {
        pub fn walk(sp: Spec, T: type, I: type, list: []const T, arr: *std.ArrayList(I)) void {
            for (list) |item| {
                if (@field(item, "spec") == null or sp.filtered(@field(item, "spec").?)) {
                    arr.appendSlice(@field(item, "data")) catch unreachable;
                }
            }
        }
    };

    // defaults
    fns.walk(spec, PlatformIncludePaths, []const u8, &IPATH, &ipaths);
    fns.walk(spec, PlatformLinkPaths, []const u8, &LPATH, &lpaths);
    fns.walk(spec, PlatformLink, []const u8, &LINK, &links);
    fns.walk(spec, PlatformMacros, Macro, &MACROS, &macros);
    fns.walk(spec, PlatformCflags, []const u8, &FLAGS, &cflags);

    // for this module
    if (info.include_paths) |ip| {
        fns.walk(spec, PlatformIncludePaths, []const u8, ip, &ipaths);
    }
    if (info.link_paths) |lp| {
        fns.walk(spec, PlatformLinkPaths, []const u8, lp, &lpaths);
    }
    if (info.links) |l| {
        fns.walk(spec, PlatformLink, []const u8, l, &links);
    }
    if (info.macros) |m| {
        fns.walk(spec, PlatformMacros, Macro, m, &macros);
    }
    if (info.flags) |f| {
        fns.walk(spec, PlatformCflags, []const u8, f, &cflags);
    }
    if (info.src_asm) |a| {
        fns.walk(spec, PlatformSrc, []const u8, a, &asmsrc);
    }
    fns.walk(spec, PlatformSrc, []const u8, info.src_cpp, &cxxsrc);

    const mod = b.addModule(info.name, .{
        .target = t,
        .optimize = o,
        .link_libcpp = true,
        .link_libc = true,
    });

    const compile = switch (info.kind) {
        .static => b.addLibrary(.{
            .name = info.name,
            .root_module = mod,
            .linkage = .static,
        }),
        .shared => b.addLibrary(.{
            .name = info.name,
            .root_module = mod,
            .linkage = .dynamic,
        }),
        .exe => b.addExecutable(.{
            .root_module = mod,
            .name = info.name,
            .link_libc = true,
        }),
    };
    compile.linkLibC();
    compile.linkLibCpp();

    for (macros.items) |d| {
        mod.addCMacro(d.name, d.val);
    }

    for (ipaths.items) |i| {
        mod.addIncludePath(root.join(b.allocator, i) catch unreachable);
    }

    for (lpaths.items) |lp| {
        mod.addLibraryPath(root.join(b.allocator, lp) catch unreachable);
    }

    for (links.items) |l| {
        mod.linkSystemLibrary(l, .{});
    }

    mod.addCSourceFiles(.{
        .files = cxxsrc.items,
        .flags = cflags.items,
        .root = root,
        .language = .cpp,
    });

    mod.addCSourceFiles(.{ .files = asmsrc.items, .root = root, .language = .assembly });

    if (info.depends_on) |deps| {
        for (deps) |d| {
            mod.linkLibrary(d);
        }
    }

    return compile;
}
