cmake_minimum_required(VERSION 3.16)
project(isaac_renode_cfu CXX)

# VIL_DIR must contain the pinned, patched CFU integration sources prepared by
# CFU-Playground's scripts/setup. See that file for exact source revisions.
foreach(required CFU_ROOT VIL_DIR CFU_RTL)
  if(NOT DEFINED ${required})
    message(FATAL_ERROR "Set ${required}")
  endif()
endforeach()
foreach(source
    "${CFU_ROOT}/common/renode-verilator-integration/sim_main.cpp"
    "${VIL_DIR}/src/renode_cfu.cpp"
    "${VIL_DIR}/src/buses/cfu.cpp"
    "${VIL_DIR}/renode_imports.h"
    "${CFU_RTL}")
  if(NOT EXISTS "${source}")
    message(FATAL_ERROR "Missing Renode integration input: ${source}")
  endif()
endforeach()

find_package(verilator REQUIRED)
add_library(Vtop SHARED
  "${CFU_ROOT}/common/renode-verilator-integration/sim_main.cpp"
  "${VIL_DIR}/src/renode_cfu.cpp"
  "${VIL_DIR}/src/buses/cfu.cpp")
target_include_directories(Vtop PRIVATE "${VIL_DIR}")
verilate(Vtop SOURCES "${CFU_RTL}" TOP_MODULE Cfu PREFIX Vcfu
  VERILATOR_ARGS -Wno-WIDTH)
