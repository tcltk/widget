# util-number.tcl --
#
#	This file implements package ::Utility::number, which  ...
#
# Copyright (c) 1997-1999 Jeffrey Hobbs
#
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#

#package require NAME VERSION
package provide ::Utility::number 1.0

namespace eval ::Utility::number {;

namespace export -clear *

# largest_int --
#   Finds the largest recognized int in Tcl for the platform
# Arguments:
#   none
# Results:
#   Returns the largest allowed value for an int (for exprs and stuff)
#
;proc largest_int {} {
    set int 1
    set exp 7; # assume we get at least 8 bits
    while {$int > 0} { set int [expr {1 << [incr exp]}] }
    expr {$int-1}
}

# int_bits --
#   Finds the number of bits in an int
# Arguments:
#   none
# Results:
#   Returns the numbers of bits in an int
#
;proc int_bits {} {
    set int 1
    set exp 7; # assume we get at least 8 bits
    while {$int > 0} { set int [expr {1 << [incr exp]}] }
    # pop up one more, since we start at 0
    incr exp
}

# get_square_size --
#   gets the minimum square size for an input
# Arguments:
#   num		number
# Returns:
#   returns smallest square size that would fit number
#
;proc get_square_size num {
    set i 1
    while {($i*$i) < $num} { incr i }
    return $i
}


# dec2roman --
#   converts a decimal to roman numeral
# Arguments:
#   x		number in decimal format
# Returns:
#   roman numeral
#
;proc dec2roman {x} {
    set result ""
    foreach [list val roman] [list 1000 M 900 CM 500 D 400 CD 100 C 90 XC \
	    50 L 40 XL 10 X 9 IX 5 V 4 IV 1 I] {
	while {$x >= $val} {
	    append result $roman
	    incr x -$val
	}
    }
    return $result
}

# bin2hex --
#   converts binary to hex number
# Arguments:
#   bin		number in binary format
# Returns:
#   hexadecimal number
#
;proc bin2hex bin {
    ## No sanity checking is done
    array set t {
	0000 0 0001 1 0010 2 0011 3 0100 4
	0101 5 0110 6 0111 7 1000 8 1001 9
	1010 a 1011 b 1100 c 1101 d 1110 e 1111 f
    }
    set diff [expr {4-[string length $bin]%4}]
    if {$diff != 4} {
        set bin [format %0${diff}d$bin 0]
    }
    regsub -all .... $bin {$t(&)} hex
    return [subst $hex]
}


# hex2bin --
#   converts hex number to bin
# Arguments:
#   hex		number in hex format
# Returns:
#   binary number (in chars, not binary format)
#
;proc hex2bin hex {
    set t [list 0 0000 1 0001 2 0010 3 0011 4 0100 \
	    5 0101 6 0110 7 0111 8 1000 9 1001 \
	    a 1010 b 1011 c 1100 d 1101 e 1110 f 1111]
    regsub {^0[xX]} $hex {} hex
    return [string map -nocase $t $hex]
}

# commify --
#   puts commas into a decimal number
# Arguments:
#   num		number in acceptable decimal format
#   sep		separator char (defaults to English format ",")
# Returns:
#   number with commas in the appropriate place
#
proc commify {num {sep ,}} {
    while {[regsub {^([-+]?\d+)(\d\d\d)} $num "\\1$sep\\2" num]} {}
    return $num
}

# isluhn --
#   Checks whether a given number is a valid credit card number
# Mod 10 Rules					  
# The rules for a Mod 10 check: 			  
# The credit card number must be between 13 and 16 digits. 
#   The credit card number must start with: 	  
# 	  4 for Visa Cards 			  
# 	  37 for American Express Cards 		  
# 	  5 for MasterCards 			  
# 	  6 for Discover Cards 			  
#   If the credit card number is less then 16 digits add zeros to
#   the beginning to make it 16 digits.		  
#   Multiply each digit of the credit card number by the
#   corresponding digit of the mask, and sum the results together.
#   Once all the results are summed divide by 10, if there is no
#   remainder then the credit card number is valid.
# For a card with an even number of digits, double every odd numbered digit
# and substract 9 if the product is greater than 9. Add up all the even
# digits as well as the doubled odd digits, and the result must be a
# multiple of 10 or it's not a valid card. If a card has an odd number of
# digits, perform the same addition, doubling the even numbered digits
# instead...
# Arguments:
#   num		card num to check
# Results:
#   Returns 0/1
#
proc isluhn {cardnum} {
    regsub -all {[^0-9]} $cardnum {} cardnum
    #set cardnum [format %.16d $cardnum]
    set len [string length $cardnum]
    if {$len < 13 || $len > 16} { return 0 }
    set i -1
    set double [expr {!($len%2)}]
    set chksum 0
    while {[incr i]<$len} {
	set c [string index $cardnum $i]
	if {$double} {if {[incr c $c] >= 10} {incr c -9}}
	incr chksum $c
	set double [expr {!$double}]
    }
    return [expr {($chksum%10)==0}]
}

variable symbols 0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ
variable baserng 0123456789abcdefghijklmnopqrstuvwxyz
variable baseary
array set baseary {
    0  0 1  1 2  2 3  3 4  4 5  5 6  6 7  7 8  8 9  9
    a 10 b 11 c 12 d 13 e 14 f 15 g 16 h 17 i 18 j 19
    10 a 11 b 12 c 13 d 14 e 15 f 16 g 17 h 18 i 19 j
    k 20 l 21 m 22 n 23 o 24 p 25 q 26 r 27 s 28 t 29
    20 k 21 l 22 m 23 n 24 o 25 p 26 q 27 r 28 s 29 t
    u 30 v 31 w 32 x 33 y 34 z 35
    30 u 31 v 32 w 33 x 34 y 35 z
}

proc base2base {num srcbase destbase} {
    return [dec2base [base2dec $num $srcbase] $destbase]
}

proc dec2base {num base} {
    # convert a decimal num to any base (2..36)
    # supports fractions
    # this actually accepts any valid Tcl int
    variable baserng
    variable baseary

    if {$base < 2 || $base > 36} {
	return -code error "base must be between 2 and 36"
    }
    set rng {^([0-9]+)(.[0-9]+)?$}
    if {![regexp $rng $num junk int frac]} {
	return -code error "invalid decimal number \"$num\""
    }
    if {int($int) < $base} {
	# use the int() above to ensure it is numeric
	set value $baseary($int)
    } elseif {$base == 8} {
	# format will be faster
	set value [format %o $int]
    } elseif {$base == 16} {
	# format will be faster
	set value [format %x $int]
    } else {
	set rad 0
	set val 1
	while {$int > $val} { set val [expr {pow($base,[incr rad])}] }
	set result ""
	while {$int > 0} {
	    set pow [expr {int(pow($base,$rad))}]
	    set red [expr {int($int/$pow)}]
	    set int [expr {$int-($pow*$red)}]
	    append result $baseary($red)
	    incr rad -1
	}
	incr rad
	while {$rad} {
	    append result 0
	    incr rad -1
	}
	set value [string trimleft $result 0]
    }
    if {[string compare {} $frac] && ($frac != 0.0)} {
	set rad -1
	set rest ""
	# This is limited to a certain granularity
	while {$frac > 1.0e-12} {
	    set pow [expr {(pow($base,$rad))}]
	    set red [expr {int($frac/$pow)}]
	    set frac [expr {$frac-($pow*$red)}]
	    append rest $baseary($red)
	    incr rad -1
	}
	return $value.$rest
    }
    return $value
}

proc base2dec {num base} {
    # convert any base number (2..36) to decimal
    # supports fractions
    variable baserng
    variable baseary

    if {$base < 2 || $base > 36} {
	return -code error "base must be between 2 and 36"
    }
    set rng [string range $baserng 0 [expr {$base-1}]]
    if {![regexp "^(\[$rng\]+).?(\[$rng\]+)?\$" \
	    [string tolower $num] junk int frac]} {
	return -code error "number may only contain chars \"\[$rng\]\""
    }
    if {$base == 16} {
	# format will be faster
	set value [format %d 0x$int]
    } elseif {$base == 8} {
	# format will be faster
	set value [format %d 0$int]
    } else {
	set rad [string length $int]
	set value 0
	foreach c [split $int {}] {
	    incr rad -1
	    set value [expr {$value+(int(pow($base,$rad))*$baseary($c))}]
	}
    }
    if {[string compare {} [string trimright $frac 0]]} {
	set rad 0
	set rest 0.0
	foreach c [split $frac {}] {
	    incr rad
	    set rest [expr {$rest+($baseary($c)/pow($base,$rad))}]
	}
	return [expr {$value+$rest}]
    }
    return $value
}

proc add_baseX {numA numB} {
    # add two numbers in any base that can be expressed as a string of 
    # unique symbols
    #
    # John Ellson <ellson@lucent.com>

    variable symbols
    set base [string length $symbols]
    set idxA [string length $numA]
    set idxB [string length $numB]
    set carry 0
    set result ""
    while {$idxA || $idxB || $carry} {
	if {$idxA} {
	    set digA [string index $numA [incr idxA -1]]
	    set decA [string first $digA $symbols]
	    if {$decA < 0} {
		puts stderr "invalid digit \"$digA\""
		return -1
	    }
	} else {
	    set decA 0
	}
	if {$idxB} {
	    set digB [string index $numB [incr idxB -1]]
	    set decB [string first $digB $symbols]
	    if {$decB < 0} {
		puts stderr "invalid digit \"$digB\""
		return -1
	    }
	} else {
	    set decB 0
	}
	set sumdec [expr {$decA + $decB + $carry}]
	if {$sumdec >= $base} {
	    set carry 1
	    incr sumdec -$base
	} else {
	    set carry 0
	}
	set result [string index $symbols $sumdec]$result
    }
    return $result
}  

}
