# util-mail.tcl --
#
#	This file implements package ::Utility::mail, which  ...
#
# Copyright (c) 1998-1999 Jeffrey Hobbs
#
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#

#package require NAME VERSION
package provide ::Utility::mail 1.0

namespace eval ::Utility::mail {;

namespace export -clear *

;proc sendmail {args} {
    # cheap getopts, no error handling
    array set opts [list -to {} -from {} -body {} \
	    -fields {} -subject {} -attach {}]
    foreach {key val} $args {
	if {[info exists opts($key)]} { set opts($key) $val }
    }
    if {[string match {} $opts(-to)] || [string match {} $opts(-from)]} {
	cgi_die "Error: -to and -from must be specified to sendmail\
		\n[info level 0]"
    }
    if {[string length $opts(-attach)] && \
	    [catch {open $opts(-attach) r} atfid]} {
	cgi_die "Error: couldn't find file to attach \"$opts(-attach)\""
    }
    set mailprog "/usr/lib/sendmail -t -oi"
    if {[catch {open "|$mailprog" r+} mailfid]} {
	cgi_die "Error: couldn't execute \"$mailprog\"" $mailfid
    }
    puts $mailfid "From: $opts(-from)"
    puts $mailfid "To: $opts(-to)"
    puts $mailfid "Subject: AutoSSI $opts(-subject)"
    if {[string length $opts(-fields)]} {
	puts $mailfid $opts(-fields)
    }
    if {[string length $opts(-attach)] && [info exists atfid]} {
	set bound "----NEXT_PART_[clock seconds].[pid]"
	puts $mailfid "Content-Type: multipart/mixed;\n\tboundary=\"$bound\""

	append pre "This message is in MIME format. " \
		"Since your mail reader does not understand this format," \
		"\nsome or all of this message may not be legible.\n\n"
	append body "Content-Type: text/plain;\n" \
		"\tcharset=\"iso-8859-1\"\n" \
		"Content-Transfer-Encoding: quoted-printable\n\n"
	set data [read $atfid]
	close $atfid
	if {[info tclversion]<8.1 || [string first \0 $data]>=0} {
	    append attach "Content-Type: application/octet-stream;\n" \
		    "\tname=\"$opts(-attach)\"\n" \
		    "Content-Disposition: attachment;\n" \
		    "\tfilename=\"$opts(-attach)\"\n\n"
	} else {
	    append attach "Content-Type: text-plain;\n" \
		    "\tcharset=\"iso-8859-1\"\n" \
		    "\tname=\"$opts(-attach)\"\n" \
		    "Content-Transfer-Encoding: quoted-printable\n" \
		    "Content-Disposition: attachment;\n" \
		    "\tfilename=\"$opts(-attach)\"\n\n"
	}
	set len [string length "$pre--$bound\n$body$opts(-body)\n--$bound\n$attach$data\n--$bound--"]
	puts $mailfid "Content-Length: $len\n"
	puts $mailfid "$pre--$bound\n$body$opts(-body)\n--$bound\n$attach$data\n--$bound--"
    } else {
	puts $mailfid "\n$opts(-body)"
    }

    if {[catch {close $mailfid} err]} { puts stderr $err }

}

variable SMTP
array set SMTP [list socket 25]

proc smtpmail {host to from subject text} {
    # Send a Mail with the following command :
    # send_SMTP_mail <SMTP_HOST> <Recipient> <From> <Subject> <Text>

    variable SMTP

    set socket [socket $host $SMTP(socket)]
    fconfigure $socket -buffering line
    puts $socket "MAIL From:<$from>"
    gets $socket
    foreach addr $to {
	puts $socket "RCPT To:<$addr>"
    }
    gets $socket
    puts $socket DATA
    gets $socket
    puts $socket "From: <$from>\nTo: <$recipients>\nSubject: $subject\n"

    foreach line [split $text \n] {
	puts $socket [join $line]
    }
    puts $socket .\nQUIT
    gets $socket
    close $socket
}

}; # end namespace
