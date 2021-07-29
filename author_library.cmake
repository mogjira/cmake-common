# requires at least cmake version 3.12 to use object libraries as deps
function(author_library lib_name)
    set(options)
    set(oneValueArgs EXPORT_NAME TYPE)
    set(multiValueArgs SOURCES PUBLIC_HEADERS DEPS PRIVATE_DEPS EXTRA_INC_DIRS)
    cmake_parse_arguments(L "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT L_TYPE)
        set(L_TYPE STATIC)
    endif()

    add_library(${lib_name} ${L_TYPE} ${L_SOURCES})

    if(${L_TYPE} STREQUAL "OBJECT")
        set_property(TARGET ${lib_name} PROPERTY POSITION_INDEPENDENT_CODE ON)
    endif()

    target_include_directories(${lib_name} PUBLIC 
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)

    if(L_EXTRA_INC_DIRS)
        target_include_directories(${lib_name} PRIVATE
            $<BUILD_INTERFACE:${L_EXTRA_INC_DIRS}>)
    endif()

    if(L_PUBLIC_HEADERS)
        set_target_properties(${lib_name} PROPERTIES PUBLIC_HEADER "${L_PUBLIC_HEADERS}")
    endif()

    if(L_EXPORT_NAME)
        set_target_properties(${lib_name} PROPERTIES EXPORT_NAME ${L_EXPORT_NAME})
    else()
        set(L_EXPORT_NAME ${lib_name})
    endif()

    set_target_properties(${lib_name} PROPERTIES
          OUTPUT_NAME ${lib_name}
          SOVERSION ${CMAKE_PROJECT_VERSION}
          RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

    add_library(${PROJECT_NAME}::${L_EXPORT_NAME} ALIAS ${lib_name})

    target_link_libraries(${lib_name} PUBLIC ${PROJECT_NAME}::Config ${L_DEPS})

    if(NOT DEFINED NO_INSTALL)
    if(L_TYPE STREQUAL "SHARED" OR L_TYPE STREQUAL "STATIC")
        install(TARGETS ${lib_name} EXPORT ${PROJECT_NAME}Targets
            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
            PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${lib_name})
    endif()
    endif()
endfunction()
