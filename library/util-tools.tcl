# util-tools.tcl --
#
#	This file implements package ::Utility::tools, which
#	contain Unix tools type commands in Tcl
#
# Copyright (c) 1998 Jeffrey Hobbs
#
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#

package require ::Utility
package provide ::Utility::tools 1.0

namespace eval ::Utility::tools {;

namespace export -clear tools*
namespace import -force ::Utility::*

proc tools {cmd args} {
    set prefix [namespace current]::tools_
    if {[string match {} [set arg [info commands $prefix$cmd]]]} {
	set arg [info commands $prefix$cmd*]
    }
    set result {}
    set code ok
    switch [llength $arg] {
	1 { set code [catch {uplevel $arg $args} result] }
	0 {
	    set arg [info commands $prefix*]
	    regsub -all $prefix $arg {} arg
	    return -code error "unknown [lindex [info level 0] 0] type\
		    \"$cmd\", must be one of: [join [lsort $arg] {, }]"
	}
	default {
	    regsub -all $prefix $arg {} arg
	    return -code error "ambiguous type \"$cmd\",\
		    could be one of: [join [lsort $arg] {, }]"
	}
    }
    return -code $code [string trimright $result \n]
}

# tools_grep --
#   cheap grep routine
# Arguments:
#   exp		regular expression to look for
#   args	files to search in
# Returns:
#   list of lines that in files that matched $exp
#
;proc tools_grep {exp args} {
    if 0 {
	## To be implemented
	-count -nocase -number -names -reverse -exact
    }
    if {[string match {} $args]} return
    set output {}
    foreach file [eval glob $args] {
	set fid [open $file]
	foreach line [split [read $fid] \n] {
	    if {[regexp $exp $line]} { lappend output $line }
	}
	close $fid
    }
    return $output
}

# tools_touch --
#   touch command in Tcl, only sets to the current time
# Arguments:
#   args	the files to touch
# Results:
#   Returns ...
#
;proc tools_touch args {
    foreach f $args {
	if {[file exists $f]} {
	    # use lstat in case it is a link
	    # otherwise it is the same as stat
	    file lstat $f fstat
	    if {$fstat(size) == 0} {
		set fid [open $f w+]
	    } else {
		set fid [open $f a+]
		fconfigure $fid -translation binary
		# read and rewrite the last byte only
		seek $fid -1 end
		set c [read $fid 1]
		seek $fid -1 current
		puts -nonewline $fid $c
	    }
	} else {
	    set fid [open $f w+]
	}
	close $fid
    }
}

proc file_uniq {infile {outfile stdout}} {
    set ifid [open $infile]
    if {![regexp {std(out|err)} $outfile]} {
	set ofid [open $outfile w]
    } else {
	set ofid $outfile
    }
    while {[gets $ifid line] != -1} {
	if {![info exists array($line)]} {
	    set array($line) {}
	    puts $ofid $line
	}
    }
    close $ifid
    if {[string compare $ofid $outfile]} {
	close $ofid
    }
}

}; # end of namespace ::Utility::tools
