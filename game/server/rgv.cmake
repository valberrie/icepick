include(episodic.cmake)

set(GAME_NAME rgv)
target_include_directories(server PUBLIC ../.. ./ rgv ../shared/rgv)
target_compile_definitions(server PUBLIC RGV_DLL USES_SAVERESTORE)
# target_sources(server PUBLIC)