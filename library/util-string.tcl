# util-string.tcl --
#
#	This file implements package ::Utility::string, which  ...
#
# Copyright (c) 1997-1999 Jeffrey Hobbs
#
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
#

#package require NAME VERSION
package provide ::Utility::string 1.0; # SET VERSION

namespace eval ::Utility::string {;

namespace export -clear *

# string_ord --
#   ordinals of a string, returns list comprised of chars ordinalized
#	 ctype ord character
#		 Convert a character into its decimal numeric value
#	 ctype char number
#		 Converts the numeric value, string, to an ASCII character

# split - split by multi-char string

#	 translit inrange outrange string (mesh with ord AND char)
#		 Translate characters in string, changing characters
#		 occurring in inrange to the corresponding character in
#		 outrange. Inrange and outrange may be list of characters
#		 or a range in the form `A-M'.

# string_reverse --
#   reverses input string
# Arguments:
#   s		input string to reverse
# Returns:
#   string with chars reversed
#
;proc string_reverse s {
    if {[set i [string len $s]]} {
	while {$i} {append r [string index $s [incr i -1]]}
	return $r
    }
}
proc reverse s {
    set t ""
    set len [string len $s]
    for {} {$len >= 0} {} {
	append t [string index $s [incr len -1]]
    }
    return $t
}

# obfuscate --
#   If I describe it, it ruins it...
# Arguments:
#   s		input string
# Returns:
#   output
#
;proc obfuscate s {
    if {[set len [string len $s]]} {
	set i -1
	while {[incr i]<$len} {
	    set c [string index $s $i]
	    if {[regexp "\[\]\\\[ \{\}\t\n\"\]" $c]} {
		append r $c
	    } else {
		scan $c %c c
		append r \\[format %0.3o $c]
	    }
	}
	return $r
    }
}

# untabify --
#   removes tabs from a string, replacing with appropriate number of spaces
#   There should be no newlines in the string (do a split $str \n and pass
#   each line to this proc).
# Arguments:
#   str		input string
#   tablen	tab length, defaults to 8
# Returns:
#   string sans tabs
#
;proc untabify {str {tablen 8}} {
    set out {}
    while {[set i [string first "\t" $str]] != -1} {
	set j [expr {$tablen - ($i % $tablen)}]
	append out [string range $str 0 [incr i -1]][format %*s $j { }]
	set str [string range $str [incr i 2] end]
    }
    return $out$str
}

# tabify --
#   converts excess spaces to tab chars
# Arguments:
#   str		input string
#   tablen	tab length, defaults to 8
# Returns:
#   string with tabs replacing excess space where appropriate
#
;proc tabify {str {tablen 8}} {
    ## We must first untabify so that \t is not interpreted to be one char
    set str [untabify $str]
    set out {}
    while {[set i [string first { } $str]] != -1} {
	## Align i to the upper tablen boundary
	set i [expr {$i+$tablen-($i%$tablen)-1}]
	set s [string range $str 0 $i]
	if {[string match {* } $s]} {
	    append out [string trimright $s { }]\t
	} else {
	    append out $s
	}
	set str [string range $str [incr i] end]
    }
    return $out$str
}

# wrap_lines --
#   wraps text to a specific max line length
# Arguments:
#   txt		input text
#   len		desired max line length+1, defaults to 75
#   P		paragraph boundary chars, defaults to \n\n
#   P2		substitute for $P while processing, defaults to \254
#		this char must not be in the input text
# Returns:
#   text with lines no longer than $len, except where a single word
#   is longer than $len chars.  Does not preserve paragraph boundaries.
#
;proc wrap_lines "txt {len 75} {P \n\n} {P2 \254}" {
    # @author Jeffrey Hobbs <jeff.hobbs@acm.org>
    #
    # @c Wraps the given <a text> into multiple lines not
    # @c exceeding <a len> characters each. Lines shorter
    # @c than <a len> characters might get filled up.
    #
    # @a text:	The string to operate on.
    # @a len:	The maximum allowed length of a single line.
    # @a P:	Paragraph boundary chars, defaults to \n\n
    # @a P2:	Substitute for $P while processing, defaults to \254
    #		this char must not be in the input text
    #
    # @r Basically <a text>, but with changed newlines to
    # @r restrict the length of individual lines to at most
    # @r <a len> characters.

    # @n This procedure is not checked by the testsuite.

    # @i wrap, word wrap

    # Convert all instances of paragraph separator $P into $P2
    # Convert all newlines into spaces and initialize the result

    regsub -all $P $txt $P2 txt
    regsub -all "\n" $txt { } txt
    incr len -1
    set out {}

    # As long as the string is longer than the intended length of
    # lines in the result:

    while {[string len $txt]>$len} {
	# - Find position of last space in the part of the text
	#   which could a line in the result.

	# - We jump out of the loop if there is none and the whole
	#   text does not contain spaces anymore. In the latter case
	#   the rest of the text is one word longer than an intended
	#   line, we cannot avoid the longer line.

	set i [string last { } [string range $txt 0 $len]]
	if {$i == -1 && [set i [string first { } $txt]] == -1} { break }

	# Get the just fitting part of the text, remove any heading
	# and trailing spaces, then append it to the result string,
	# don't close it with a newline!

	append out [string trim [string range $txt 0 [incr i -1]]]\n

	# Shorten the text by the length of the processed part and
	# the space used to split it, then iterate.

	set txt [string range $txt [incr i 2] end]
    }
    regsub -all $P2 $out$txt $P txt
    return $txt
}

}; # end of namespace ::Utility::string
