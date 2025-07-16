option(LAUNCH_TESTS "Enable launching tests" ON)

file(GLOB testsSources
  ${CMAKE_CURRENT_LIST_DIR}/*.c
)

foreach(testSource ${testsSources})
  get_filename_component(testName ${testSource} NAME_WE)
  add_executable(test-${testName} ${testSource})

  if(LAUNCH_TESTS)
    add_custom_command(
      TARGET test-${testName}
      POST_BUILD
      COMMAND test-${testName}
      COMMENT "Running test: ${testName}"
    )
  endif()
endforeach()

if(LAUNCH_TESTS)
  add_custom_target(launch-tests ALL
    DEPENDS ${testsSources}
    COMMENT "Launching all tests..."
  )
endif()

