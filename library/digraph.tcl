# digraph.tcl --
#
# This file defines the bindings for Tk widgets to provide
# procedures that allow the input of the extended latin charset
# (often referred to as digraphs).
#
# Copyright (c) 1998 Jeffrey Hobbs

package require Tk 8

namespace eval ::digraph {;

namespace export -clear digraph

variable wid
array set char {
    `A	À	A`	À	`a	à	a`	à
    'A	Á	A'	Á	'a	á	a'	á
    ^A	Â	A^	Â	^a	â	a^	â
    ~A	Ã	A~	Ã	~a	ã	a~	ã
    \"A	Ä	A\"	Ä	\"a	ä	a\"	ä
    *A	Å	A*	Å	*a	å	a*	å
    AE	Æ			ae	æ

    ,C	Ç	C,	Ç	,c	ç	c,	ç

    -D	Ð	D-	Ð	-d	ð	d-	ð

    `E	È	E`	È	`e	è	e`	è
    'E	É	E'	É	'e	é	e'	é
    ^E	Ê	E^	Ê	^e	ê	e^	ê
    \"E	Ë	E\"	Ë	\"e	ë	e\"	ë

    `I	Ì	I`	Ì	`i	ì	i`	ì
    'I	Í	I'	Í	'i	í	i'	í
    ^I	Î	I^	Î	^i	î	i^	î
    \"I	Ï	I\"	Ï	\"i	ï	i\"	ï

    ~N	Ñ	N~	Ñ	~n	ñ	n~	ñ

    `O	Ò	O`	Ò	`o	ò	o`	ò
    'O	Ó	O'	Ó	'o	ó	o'	ó
    ^O	Ô	O^	Ô	^o	ô	o^	ô
    ~O	Õ	O~	Õ	~o	õ	o~	õ
    \"O	Ö	O\"	Ö	\"o	ö	o\"	ö
    /O	Ø	O/	Ø	/o	ø	o/	ø

    `U	Ù	U`	Ù	`u	ù	u`	ù
    'U	Ú	U'	Ú	'u	ú	u'	ú
    ^U	Û	U^	Û	^u	û	u^	û
    \"U	Ü	U\"	Ü	\"u	ü	u\"	ü

    'Y	Ý	'y	ý	\"y	ÿ	y\"	ÿ

    ss	ß

    !!	¡	||	¦	\"\"	¨	,,	¸
    c/	¢	/c	¢	C/	¢	/C	¢
    l-	£	-l	£	L-	£	-L	£
    ox	¤	xo	¤	OX	¤	XO	¤
    y-	¥	-y	¥	Y-	¥	-Y	¥

    co	©	oc	©	CO	©	OC	©
    <<	«	>>	»
    ro	®	or	®	RO	®	OR	®
    -^	¯	^-	¯	-+	±	+-	±
    ^2	²	2^	²	^3	³	3^	³
    ,u	µ	u,	µ	.^	·	^.	·
    P|	Þ	|P	Þ	p|	þ	|p	þ
    14	¼	41	¼	12	½	21	½
    34	¾	43	¾	??	¿	xx	×
}

proc translate {c} {
    variable char
    if {[info exists char($c)]} {return $char($c)}
    return $c
}

proc insert {w type a k} {
    variable wid
    if {[info exists wid($w)]} {
	# This means we have already established the echar binding
	if {[info exists wid(FIRST.$w)]} {
	    # This means that we are in the middle of setting an echar
	    # By default, it will be these two chars
	    set char [translate "$wid(FIRST.$w)$a"]
	    switch -exact $type {
		TkConsole	{ tkConInsert $w $char }
		Text		{ tkTextInsert $w $char }
		Entry		{ tkEntryInsert $w $char }
		Table		{ $w insert active insert $char }
		default		{ catch { $w insert $char } }
	    }
	    bind $w <KeyPress> $wid($w)
	    unset wid($w)
	    unset wid(FIRST.$w)
	} else {
	    # This means we are getting the first part of the echar
	    if {[string compare $a {}]} {
		set wid(FIRST.$w) $a
	    } else {
		# For Text widget, after the Multi_key,
		# it does some weird things to Tk's keysym translations
		switch -glob $k {
		    apostrophe	{set wid(FIRST.$w) "'"}
		    grave	{set wid(FIRST.$w) "`"}
		    comma	{set wid(FIRST.$w) ","}
		    quotedbl	{set wid(FIRST.$w) "\""}
		    asciitilde	{set wid(FIRST.$w) "~"}
		    asciicurcum	{set wid(FIRST.$w) "^"}
		    Control* - Shift* - Caps_Lock - Alt* - Meta* {
			# ignore this anomaly
			return
		    }
		    default	{
			# bogus first char, just end state transition now
			bind $w <KeyPress> $wid($w)
			unset wid($w)
		    }
		}
	    }
	}
    } else {
	# Cache the widget's binding, it doesn't matter if there isn't one
	# If the class has a special binding, then this could be redone
	set wid($w) [bind $w <KeyPress>]
	# override the binding
	bind $w <KeyPress> [namespace code \
		"insert %W [list $type] %A %K; break"]
    }
}

# w is either a specific widget, or a class
proc digraph {w} {
    if {[winfo exists $w]} {
	# it is a specific widget
    } else {
	# it is a class of widgets
	if {[string compare [info commands digraph$w] {}]} {
	    digraph$w
	} else {
	    bind $w <<Digraph>> [namespace code \
		"insert %W [list $w] %A %K; break"]
	}
    }
}

proc digraphText args {
    bind Text <<Digraph>> [namespace code { insert %W Text %A %K; break }]
    bind Text <Key-Escape> {}
}

proc digraphEntry args {
    bind Entry <<Digraph>> [namespace code { insert %W Entry %A %K; break }]
    bind Entry <Key-Escape> {}
}

proc digraphTable args {
    bind Table <<Digraph>> [namespace code { insert %W Table %A %K; break }]
    #bind Table <Key-Escape> {}
}

proc digraphTkConsole args {
    bind TkConsole <<Digraph>> [namespace code {
	insert %W TkConsole %A %K
	break
    }
    ]
    event delete <<TkCon_ExpandFile>> <Key-Escape>
}

}; # end creation of digraph namespace

# THE EVENT YOU CHOOSE IS IMPORTANT - You should also make sure that that
# event is not bound to the class already (for example, most bind <Escape>
# to {# nothing}, but Table uses it for the reread and TkConsole uses it
# for TkCon_ExpandFile).  The Sun <Multi_key> works already, but you might
# want to define special state keys

event add <<Digraph>> <Key-Escape> <Mode_switch>


