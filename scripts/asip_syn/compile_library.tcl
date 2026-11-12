# Convert an open Liberty view to a local Synopsys database.
if {[catch {
    if {![read_lib $env(ASIP_LIBERTY)]} {error "Liberty import failed"}
    set libs [get_object_name [get_libs *]]
    if {[llength $libs] != 1} {error "Expected one library, got $libs"}
    write_lib [lindex $libs 0] -format db -output $env(ASIP_DB)
    if {![file exists $env(ASIP_DB)]} {error "Database was not written"}
} message]} {
    puts stderr "ASIP_LIBRARY_FAILED: $message"
    exit 1
}
puts "ASIP_LIBRARY_COMPLETE"
exit 0
