
   * AT   = AsserTcl    /''done''/
   * EL   = ExtraL      /''done''/
   * JS   = jstools     /''done''/
   * JT   = jultaf      /''done''/
   * PB   = Pool_Base   /''done''/
   * TclX = TclX        /''done''/

----
(EL)    oneof element list 
(TclX)  lcontain list element
        Determine if the element is a list element of list. If the
        element is contained in the list, 1 is returned, otherwise,
        0 is returned. 

(EL)    lunion list list ... 
        returns the union of the lists 

(TclX)  union lista listb
        Procedure to return the logical union of the two specified lists.
        Any duplicate elements are removed.

(EL)    lcommon list list ... 
        returns the common elements of the lists.

(TclX)  intersect lista listb
        Procedure to return the logical intersection of two lists.
        The returned list will be sorted. 

(EL)    leor list1 list2 
        returns the elements that are not shared between both lists 

(TclX)  intersect3 lista listb
        Procedure to intersects two lists, returning a list containing
        three lists: The first list returned is everything in lista that
        wasn't in listb. The second list contains the intersection of
        the two lists, and the third list contains all the elements
        that were in listb but weren't in lista. The returned lists
        will be sorted. 

(TclX)  lempty list
        Determine if the specified list is empty. If empty, 1 is
        returned, otherwise, 0 is returned. This command is an
        alternative to comparing a list to an empty string, however
        it checks for a string of all whitespaces, which is an empty
        list. 
----
(JT)    Juf::Sequence::assign LIST ?NAME ...?
        Sets value of the variables specified by the NAME arguments to
        that of the existing elements of LIST. Returns remaining list
        elements. If the number of variables exceeds the list length,
        the remaining variables will be removed.

(PB)    ::pool::list::assign varList list
        By Brent Welch. Assigns a set of variables from a list of values.
        If there are more values than variables, they are ignored. If
        there are fewer values than variables, the variables get the empty
        string. 

(TclX)  lassign list var ?var...?
        Assign successive elements of a list to specified variables.
        If there are more variable names than fields, the remaining
        variables are set to the empty string. If there are more
        elements than variables, a list of the unassigned elements
        is returned. 

        For example, 

                lassign {dave 100 200 {Dave Foo}} name uid gid longName 

        Assigns name to ``dave'', uid to ``100'', gid to ``200'', and
        longName to ``Dave Foo''. 
----
(EL)    lfind mode list pattern 
(TclX)  lmatch ?mode? list pattern
        Search the elements of list, returning a list of all elements
        matching pattern. If none match, an empty list is returned. 

        The mode argument indicates how the elements of the list are
        to be matched against pattern and it must have one of the
        following values: 

        -exact  The list element must contain exactly the same string
                as pattern. 

        -glob   Pattern is a glob-style pattern which is matched against
                each list element using the same rules as the string
                match command. 

        -regexp Pattern is treated as a regular expression and matched
                against each list element using the same rules as the
                regexp command. 

        If mode is omitted then it defaults to -glob. 

(JT)    Juf::Sequence::match PATTERN LIST
        Returns a new list with all elements of LIST matching PATTERN
        as with string match. == glob '''!'''

(PB)    ::pool::list::match list pattern
        All words not contained in list pattern are removed from list.
        In set-notation: result = intersect (list, pattern). This is
        not completely true, duplicate entries in 'list' remain in the
        result, given that they appear at all. 

(PB)    ::pool::list::filter list pattern
        All words contained in the list pattern are removed from list.
        In set-notation: result = list - pattern. Returns the set
        difference of list and pattern. '''Negative match'''.

----
(EL)    lremdup ?-sorted? list ?var?
        returns a list in which all duplactes are removed. with the
        -sorted option the command will usually be a lot faster,
        but $list must be sorted with lsort; The optional $var gives
        the name of a variable in which the removed items will be stored. 

(TclX)  lrmdups list
        Procedure to remove duplicate elements from a list. The returned
        list will be sorted. 

(PB)    ::pool::list::uniq list
        Removes duplicate entries from list. Returns the modified list. 

----
(EL)    laddnew listName ?item? ... 
        adds the items to the list if not already there 

(JT)    Juf::Sequence::append ?OPTION ...? NAME ?VALUE ...?
        Works like the Tcl builtin lappend, but considers these options: 

        -nonempty       Append only non-empty values.
        --              Marks the end of the options. The argument
                        following this one will be treated as NAME
                        even if it starts with a -. 

(TclX)  lvarcat var string ?string...?
        This command treats each string argument as a list and concatenates
        them to the end of the contents of var, forming a a single list.
        The list is stored back into var and also returned as the result.
        if var does not exist, it is created. 
----
(PB)    ::pool::list::pop listVar
        Removes the last element of the list contained in variable listVar. 
        Returns the last element of the list, or {} in case of an empty list. 

(JT)    Juf::Sequence::pop NAME ?COUNT?
        Removes COUNT element from the end of the list stored in the
        variable NAME and returns the last element removed. COUNT
        defaults to 1. 

(EL)    lpop listName ?pos? 
        returns the last element from a list, thereby removing it from
        the list. If pos is given it will return the pos element of the
        list. 

(JT)    Juf::Sequence::shift NAME ?COUNT?
        Removes COUNT element from the list stored in the variable NAME
        and returns the last element removed. COUNT defaults to 1.

(EL)    lshift listName 
        returns the first element from a list, thereby removing it from
        the list. 

(PB)    ::pool::list::shift listVar
        The list stored in the variable listVar is shifted down by one. 
        Returns the first element of the list stored in listVar, or {}
        for an empty list. The latter is not a sure signal, as the list
        may contain empty elements. 

(PB)    ::pool::list::remove listVar position
        Removes the item at position from the list stored in variable
        listVar. 

(PB)    ::pool::list::exchange listVar position newItem
        Removes the item at position from the list stored in variable
        listVar and inserts newItem in its place. Returns the changed list. 

(TclX)  lvarpop var ?indexExpr? ?string?
        The lvarpop command pops (deletes) the element indexed by the
        expression indexExpr from the list contained in the variable var.
        If index is omitted, then 0 is assumed. If string, is specified,
        then the deleted element is replaced by string. The replaced or
        deleted element is returned. Thus ``lvarpop argv 0'' returns the
        first element of argv, setting argv to contain the remainder of the
        string. 

        If the expression indexExpr starts with the string end, then end
        is replaced with the index of the last element in the list. If the
        expression starts with len, then len is replaced with the length
        of the list. 
----
(PB)    ::pool::list::push listvar args
        The same as 'lappend', provided for symmetry only. 

(EL)    lpush listName ?item? ?position? 
        opposite of lpop. 

(EL)    lunshift listName ?item? 
        opposite of lshift: prepends ?item? to the list. 

(PB)    ::pool::list::prepend listVar newElement
(PB)    ::pool::list::unshift listVar newElement
        The list stored in the variable listVar is shifted up by one.
        newElement is inserted afterward into the now open head position. 

(TclX)  lvarpush var string ?indexExpr?
        The lvarpush command pushes (inserts) string as an element in the
        list contained in the variable var. The element is inserted before
        position indexExpr in the list. If index is omitted, then 0 is
        assumed. If var does not exists, it is created. 

        If the expression indexExpr starts with the string end, then end
        is replaced with the index of the last element in the list. If
        the expression starts with len, then len is replaced with the
        length of the list. Note the a value of end means insert the
        string before the last element. 
----
(PB)    ::pool::list::head list
        Returns the first element of list. 

(PB)    ::pool::list::last list
        Returns the last element of list. 

(PB)    ::pool::list::prev list
        Returns everything before the last element of list. 

(PB)    ::pool::list::tail list
        Returns everything behind the first element of list. 

----
(EL)    remove listName ?item? ... 
        removes the items from the list 

(PB)    ::pool::list::delete listVar value
        By Brent Welch. Deletes an item from the list stored in
        listVar, by value. Returns 1 if the item was present, else 0. 

----
(EL)    lsub list ?-exclude? index_list
        create a sublist from a set of indices. When -exclude is specified,
        the elements of which the indexes are not in the list will be given. 
        eg.:

        % lsub {Ape Ball Field {Antwerp city} Egg} {0 3}
        Ape {Antwerp city}
        % lsub {Ape Ball Field {Antwerp city} Egg} -exclude {0 3}
        Ball Field Egg

(PB)    ::pool::list::select list indices
        Idea from a thread in c.l.t.
        General permutation / selection of list elements. Takes the elements
        of list whose indices were given to the command and returns a new list
        containing them, in the specified order. 

----

(EL)    lcor 
        gives the positions of the elements in list in the reference list.
        If an element is not found in the reference list, it returns -1.
        Elements are matched only once. eg.:

        % lcor {a b c d e f} {d b}
        3 1
        % lcor {a b c d e f} {b d d}
        1 3 -1

(EL)    llremove ?-sorted? list1 list2 ?var?
        returns a list with all items in list1 that are not in list2. with
        the -sorted option the command will usually be a lot faster, but
        both given lists must be sorted with lsort; The optional $var give
        the name of a variable in which the removed items will be stored. 

(EL)    lmerge ?list1? ?list2? ??spacing?? 
        merges two lists into one eg.:

        % lmerge {a b c} {1 2 3}
        a 1 b 2 c 3
        % lmerge {a b c d} {1 2} 2
        a b 1 c d 2

(EL)    lunmerge ?list? ?spacing? ?var?
        unmerges items from a list to the result; the remaining items are
        stored in the given variable ?var? eg.:

        % lunmerge {a 1 b 2 c 3}
        a b c
        % lunmerge {a b 1 c d 2} 2 var
        a b c d
        % set var
        1 2

(EL)    lset listName ?item? ?indexlist? 
        sets all elements of the list at the given indices to value ?item? 

(EL)    larrayset array varlist valuelist 
        sets the values of valuelist to the respective elements in varlist
        for the given array.

(EL)    lregsub ?switches? exp list subSpec 
        does a regsub for each element in the list, and returns the resulting
        list. eg.:

        % lregsub {c$} {afdsg asdc sfgh {dfgh shgfc} dfhg} {!}
        afdsg asd! sfgh {dfgh shgf!} dfhg
        % lregsub {^([^.]+)\.([^.]+)$} {start.sh help.ps h.sh} {\2 \1}
        {sh start} {ps help} {sh h}

(PB)    ::pool::list::reverse list
        Returns the reversed list. 

(PB)    ::pool::list::projection list column
        Treats list as list of lists and extracts the column'th element of
        each list item. If list is seen as matrix, then the procedure
        returns the data of the specified column. 

(PB)    ::pool::list::apply cmd list
        Applies cmd to all entries of list and concatenates the
        individual results into a single list. The cmd must accept exactly
        one argument, which will be the current element.

(PB)    ::pool::list::lengthOfLongestEntry (list)
        Determines the length of the longest entry contained in the list.

(AT)    lall item_list list expr
        List universal quantifier: evaluates expr for all items or
        item sequences, and returns 1 if the expresson is true over
        the whole list, and 0 otherwise

(AT)    lexit item_list list expr
        List existential quantifier: evaluates expr for all items or
        item sequences, and returns 1 if the expresson is true for any
        item in the list, and 0 otherwise

(JS)    j:longest_match
        find the longest common initial string in a list

