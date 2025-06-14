project(tier0)
add_library(tier0 SHARED
        assert_dialog.cpp
		commandline.cpp
		cpu.cpp
		cpumonitoring.cpp
		cpu_usage.cpp
		dbg.cpp
		dynfunction.cpp
		fasttimer.cpp
		# InterlockedCompareExchange128.masm
		mem.cpp
		mem_helpers.cpp
		memdbg.cpp
		memstd.cpp
		memvalidate.cpp
		minidump.cpp
		pch_tier0.cpp
		#pmc360.cpp
		PMELib.cpp
		progressbar.cpp
		security.cpp
		systeminformation.cpp
		stacktools.cpp
		thread.cpp
		threadtools.cpp
		tier0_strtools.cpp
		tslist.cpp
		vprof.cpp
)

target_include_directories(tier0 PUBLIC ../thirdparty/SDL)

# TODO: change the names of these macros
target_compile_definitions(tier0 PUBLIC TIER0_DLL_EXPORT=1 WAF_CFLAGS=${CMAKE_CXX_FLAGS} WAF_LDFLAGS=${CMAKE_SHARED_LINKER_FLAGS})

if(WIN32)
    target_sources(tier0 PUBLIC assert_dialog.rc platform.cpp pme.cpp vcrmode.cpp win32consoleio.cpp)
    if(ARCHITECTURE STREQUAL 64bit)
        target_sources(tier0 PUBLIC InterlockedCompareExchange128.S)
    endif()
else()
    target_sources(tier0 PUBLIC cpu_posix.cpp platform_posix.cpp pme_posix.cpp vcrmode_posix.cpp)
endif()

install(TARGETS tier0 DESTINATION bin)
