function(author_library lib_name)
    set(options)
    set(oneValueArgs EXPORT_NAME TYPE)
    set(multiValueArgs SOURCES PUBLIC_HEADERS DEPS PRIVATE_DEPS OBJ_DEPS EXTRA_INC_DIRS)
    cmake_parse_arguments(L "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT options)
        set(L_TYPE STATIC)
    endif()

    add_library(${lib_name} ${L_TYPE} ${L_SOURCES})

    target_include_directories(${lib_name} PUBLIC 
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)

    if(L_EXTRA_INC_DIRS)
        target_include_directories(${lib_name} PRIVATE 
            $<BUILD_INTERFACE:${L_EXTRA_INC_DIRS}>)
    endif()

    target_link_libraries(${lib_name} PUBLIC ${PROJECT_NAME}::Config ${L_DEPS})

    if (OBJ_DEPS)
        message("obj deps: ${L_OBJ_DEPS}")
        target_link_libraries(${lib_name} $<TARGET_OBJECTS:${L_OBJ_DEPS}>)
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

    install(TARGETS ${lib_name} EXPORT ${PROJECT_NAME}Targets
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${lib_name})
endfunction()
