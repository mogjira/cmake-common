function(author_tests T_LIB)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs SOURCES)
    cmake_parse_arguments(T "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    foreach(SRC ${T_SOURCES})
        string(REPLACE ".c" "" TEST ${SRC})
        add_executable(${TEST} ${SRC})
        target_link_libraries(${TEST} ${T_LIB})
        add_test(${TEST} ${TEST})
    endforeach()
endfunction()
