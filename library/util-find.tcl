The following operands are supported:

path           a path name of a starting point in the directory hierarchy.

The first argument that starts with a -, or is a ! or  a  (,
and  all  subsequent  arguments  will  be  interpreted as an
expression made up of the following primaries and operators.
In  the  descriptions, wherever n is used as a primary argu-
ment, it will be interpreted as a decimal integer optionally
preceded by a plus (+) or minus (-) sign, as follows:

+n             more than n
n              exactly n
-n             less than n.

Valid expressions are:

-atime n	True if the file was  accessed	n  days	 ago.
		The  access  time  of  directories in path is
		changed by find itself.

-ctime n	True if the file's status was changed n	 days
		ago.

-eval command	True if the executed command returns  a	 zero
		value  as  exit	 status.   The end of command
		must be punctuated by an  escaped  semicolon.
		A  command  argument  {}  is  replaced by the
		current path name.

-follow		Always	True; causes symbolic links to be fol-
		lowed.	 When  following symbolic links, find
		keeps track of	the  directories  visited  so
		that  it can detect infinite loops; for exam-
		ple, such a loop would occur  if  a  symbolic
		link pointed to an ancestor.  This expression
		should not be used with the -type  l  expres-
		sion.

-group gname	True if the file belongs to the group  gname.
		If  gname  is  numeric and does not appear in
		the /etc/group file, it is taken as  a	group
		ID.

-inum n		True if the file has inode number n.

-links n	True if the file has n links.

-ls		Always	true;  prints	current	 path	name
		together   with	 its  associated  statistics.
		These include (respectively):

		 inode number
		 size in kilobytes (1024 bytes)
		 protection mode
		 number of hard links
		 user
		 group
		 size in bytes
		 modification time.

		If the file is a special file the size	field
		will  instead  contain	the  major  and minor
		device numbers.

		If the file is a symbolic link	the  pathname
		of  the linked-to file is printed preceded by
		`->'.  The format is identical to that of  ls
		-gilds (see ls(1)).

		Note: Formatting is done internally,  without
		executing the ls program.

-mtime n	True if the file's data was modified  n	 days
		ago.

-name pattern	True if	 pattern  matches  the	current	 file
		name.	Normal	shell  file  name  generation
		characters  (see  sh(1))  may  be  used.    A
		backslash  (\) is used as an escape character
		within the pattern.  The  pattern  should  be
		escaped	 or  quoted when find is invoked from
		the shell.

-newer file	True if the current file  has  been  modified
		more recently than the argument file.

-perm [-]mode	The mode argument is used to  represent	file
		mode bits.  It will be identical in format to
		the  <symbolicmode>  operand   described   in
		chmod(1), and will be interpreted as follows.
		To start, a template will be assumed with all
		file mode bits cleared.	 An op symbol of:

		+    will set the appropriate  mode  bits  in
			the template;

		-    will clear the appropriate bits;

		=    will  set	the  appropriate  mode	bits,
			without	 regard	 to the contents of pro-
			cess' file mode creation mask.

		The op symbol of - cannot be the first	char-
		acter of mode; this avoids ambiguity with the
		optional leading hyphen.  Since	 the  initial
		mode  is all bits off, there are not any sym-
		bolic modes that need to use - as  the	first
		character.

		If the hyphen is omitted,  the	primary	 will
		evaluate  as  true  when  the file permission
		bits exactly match the value of the resulting
		template.

		Otherwise, if mode is prefixed by  a  hyphen,
		the primary will evaluate as true if at least
		all the bits in the  resulting	template  are
		set in the file permission bits.

-perm [-]onum	True if the  file  permission  flags  exactly
		match  the  octal number onum (see chmod(1)).
		If onum is prefixed by a minus sign (-), only
		the  bits  that	 are set in onum are compared
		with  the  file	 permission  flags,  and  the
		expression evaluates true if they match.

-print		Always true; causes the current path name  to
		be printed.

-prune		Always	yields	true.	Do  not	examine	 any
		directories  or files in the directory struc-
		ture below the pattern just matched.  See the
		examples, below.

-puts

-size n[c]	True if the file is n blocks long (512	bytes
		per  block).   If  n  is followed by a c, the
		size is in bytes.

-type c		True if the type of the file is c, where c is
		b,  c,	d, l, p, or f for block special file,
		character special file,	 directory,  symbolic
		link,  fifo  (named  pipe),  or	 plain	file,
		respectively.

-user uname	True if the file belongs to the	 user  uname.
		If  uname is numeric and does not appear as a
		login name in the  /etc/passwd	file,  it  is
		taken as a user ID.

proc find {dir args} {
}

    proc rglob {{pat *}} {
	set result [glob -nocomplain $pat]
	foreach f $result {
	    if {[file isdirectory $f]} {
		lappend result [rglob [file join $f $pat]]
	    }
	}
	return $result
    }

