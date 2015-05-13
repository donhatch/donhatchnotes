To get psql running on Linux:
    % chkconfig --list | grep sql
    postgresql      0:off   1:off   2:off   3:off   4:off   5:off   6:off
    mysqld          0:off   1:off   2:off   3:off   4:off   5:off   6:off
    # chkconfig postgresql on
    # service postgresql start
To add a user hatch (same as my actual login name on the computer):
    # su postgres
     $ psql -e template1                     (-e shows commands sent to server)
      template1=# \h create user
            Command:     CREATE USER
            Description: define a new database user account
            Syntax:
            CREATE USER name [ [ WITH ] option [ ... ] ]

            where option can be:

                  SYSID uid
                | [ ENCRYPTED | UNENCRYPTED ] PASSWORD 'password'
                | CREATEDB | NOCREATEDB
                | CREATEUSER | NOCREATEUSER
                | IN GROUP groupname [, ...]
                | VALID UNTIL 'abstime'
      template1=# create user hatch with createdb;     (seicolon required!!!)

To get started:
    % psql -l
                List of databases
           Name    |  Owner   | Encoding
        -----------+----------+-----------
         template0 | postgres | SQL_ASCII
         template1 | postgres | SQL_ASCII
        (2 rows)
    % psql template1
        template1=> \l
                    List of databases
               Name    |  Owner   | Encoding
            -----------+----------+-----------
             template0 | postgres | SQL_ASCII
             template1 | postgres | SQL_ASCII
            (2 rows)
        template1=> \l+
                                  List of databases
               Name    |  Owner   | Encoding  |        Description
            -----------+----------+-----------+---------------------------
             template0 | postgres | SQL_ASCII |
             template1 | postgres | SQL_ASCII | Default template database
            (3 rows)
        template1=> \h create database
            Command:     CREATE DATABASE
            Description: create a new database
            Syntax:
            CREATE DATABASE name
                [ [ WITH ] [ OWNER [=] dbowner ]
                       [ LOCATION [=] 'dbpath' ]
                       [ TEMPLATE [=] template ]
                       [ ENCODING [=] encoding ] ]
        template1=> create database hatch;
        <ctrl-d>
    % psql
        hatch=> \l+
                                  List of databases
               Name    |  Owner   | Encoding  |        Description
            -----------+----------+-----------+---------------------------
             hatch     | hatch    | SQL_ASCII |
             template0 | postgres | SQL_ASCII |
             template1 | postgres | SQL_ASCII | Default template database
            (3 rows)
        hatch=> \d+
            No relations found.
        hatch=> create table my_table ( first integer not null default 0, second text);
        hatch=> \d+
                            List of relations
             Schema |   Name   | Type  | Owner | Description
            --------+----------+-------+-------+-------------
             public | my_table | table | hatch |
            (1 row)
        hatch=> \d+ my_table
                           Table "public.my_table"
             Column |  Type   |     Modifiers      | Description
            --------+---------+--------------------+-------------
             first  | integer | not null default 0 |
             second | text    |                    |
        hatch=> select * from my_table;
             first | second
            -------+--------
            (0 rows)
        hatch=> insert into my_table values (10, 'foo');
        hatch=> insert into my_table values (20, 'bar');
        hatch=> insert into my_table values (30, 'baz');
        hatch=> select * from my_table;
             first | second
            -------+--------
                10 | foo
                20 | bar
                30 | baz
            (1 row)
        hatch=> select first,second,first from my_table where first = 10 or (second <= 'car' and first = 30);
             first | second | first
            -------+--------+-------
                10 | foo    |    10
                30 | baz    |    30
            (2 rows)
        hatch=> select count(*) from my_table;
             count
            -------
                 3
            (1 row)
        hatch=> select count(second) from my_table;
             count
            -------
                 3
            (1 row)
        hatch=> select count(distinct first%4) from my_table;
             count
            -------
                 2
            (1 row)
        hatch=> delete from my_table where first = 10;
        hatch=> select * from my_table;
             first | second
            -------+--------
                20 | bar
            (1 row)
        hatch=> update my_table set second = 'baz' where first = 20;
        hatch=> delete from my_table;

        hatch=> update my_table add column third text;
        hatch=> update my_table drop column third;

        hatch=> alter table my_table rename to my_table1
        hatch=> drop table my_table1;
        hatch=> \d+
            No relations found.

        

REMEMBER:
    - commands can be spread over several lines of input
    - sql commands must be followed by semicolon,
      otherwise it will silently do nothing until you add it!
    - commands and database names are case insensitive
    - tab completion works in various contexts
    - comments using -- or /* */

Most basic commands from inside psql (from \h and \?):
    \h        help with sql commands
    \?        help on internal slash commands
    \set [NAME [VALUE]] set internal variable, or list all if no parameters
    \pset border 2      show boxes around all cells of table

    \l        List databases
    \l+       List databases in more detail
    CREATE DATABASE database1
    DROP DATABASE database1
    \c[onnect] [DBNAME|- [USER]] connect to new database

    \d        List relations (tables, indexes, sequences, views)
    \d+       List relations in more detail
    \d [NAME] Describe relation
    \d+ [NAME] Describe relation in more detail
    CREATE TABLE my_table (first integer not null default 0, second text); (for example)

    INSERT INTO my_table values (30, 'baz');  (for example)


    ??? to list everything that \pset shows?
    ??? do describe the columns of a table?  neither \d nor \d+ does it




Other resources:
        Examples at bottom of the psql man page

        Adventures in PostgreSQL
        Episode 1: Restoring a Corrupted Template1 using Template0
        http://techdocs.postgresql.org/techdocs/pgsqladventuresep1.php

        Someone else's notes:
        http://www.topology.org/linux/postgres.html

        PostgreSQL: Introductiona and Concepts  (good intro)
        http://postgresql-www.mirror.linkinnovations.com/files/documentation/books/aw_pgsql/15467.html



----------------------------------------------------------
I was using the following at ILM
where there was a python interface
but no nice command-line interface...
could maybe port this or salvage pieces if needed
============================================================================================
import poi2
db = poi2.soloXXXConnection('crashview_app/passwordGoesHere@sky.world')     # live database

# Pretty-print results of db.execute()
# like mysql and other programs do
def do(query):
    def formatEntry(entry):
        if entry is None:
            return 'null'
        elif type(entry) == poi2.OracleDate:
            return entry.dt.isoformat(sep=' ')
        else:
            return `entry`
    results = db.execute(query)
    if type(results) == int:
        print results
    else:
        colNames = results._coldescription.names
        colWidths = [max([len(colNames[iCol])]+[len(formatEntry(row[iCol])) for row in results]) for iCol in xrange(len(colNames))]
        print '|'.join(['%-*s'%(colWidth,colName) for colWidth,colName in zip(colWidths,colNames)])
        print '+'.join('-' * colWidth for colWidth in colWidths)
        for row in results:
            print '|'.join(['%-*s'%(colWidth,formatEntry(entry)) for colWidth,entry in zip(colWidths,row)])
        if len(results) > 24:
            # print col names at bottom too
            print '+'.join('-' * colWidth for colWidth in colWidths)
            print '|'.join(['%-*s'%(colWidth,colName) for colWidth,colName in zip(colWidths,colNames)])

# Find out what's been going on in last hour
do("select session_str,e.* from zeno.session_log s join zeno.event e on s.session_id=e.session_id where when_local > current_date - 1/24 order by when_local")
# Limit to a particular user
do("select session_str,e.* from zeno.session_log s join zeno.event e on s.session_id=e.session_id where zeno_user = 'dhatch' and when_local > current_date - 1/24 order by when_local")
# See just the session_log fields, for sessions started in the last hour
do("select s.* from zeno.session_log s join zeno.event e on s.session_id=e.session_id where event='START' and when_local > current_date - 1/24 order by when_local")
============================================================================================
more Q/A in ~dhatch/wrk/sql/NOTES   XXXTODO: find that and add it here!

Q: how can I group by a column,
   but make every row with NULL value in that column
   come out as a singleton group?
   Note that all the refs I see imply GROUP BY groups nulls together:
      http://technet.microsoft.com/en-us/library/ms187007(v=sql.90).aspx
      http://stackoverflow.com/questions/13566117/group-by-a-nullable-column
      http://en.wikipedia.org/wiki/Null_(SQL)
       "Because SQL:2003 defines all Null markers as being unequal to one another, a special definition was r
equired in order to group Nulls together when performing certain operations. SQL defines "any two values that
 are equal to one another, or any two Nulls", as "not distinct".[19] This definition of not distinct allows S
QL to group and sort Nulls when the GROUP BY clause (and other keywords that perform grouping) are used."

   Funny situation:
   Unfortunately, putting things with empty name in same group is not what I want.
   Fortunately, "" is NULL and NULL is a special case: (NULL=NULL) is false!
        (actually I don't know whether "" is NULL in the sql I'd be using? hmm)
   Unfortunately, GROUP BY is an even specialer case:
       it treats two NULLs as "not distinct"!

A: from SQL For Smarties:

    20.1.1 NULLs and Groups

    SQL puts the NULLs into a single group, as if they were all equal.
    The other option, which was used in some of the first SQL implementations before the standard,
    was to put each NULL into a group by itself.
    That is not an unreasonable choice.
    But to make a meaningful choice between the two options,
    you woul dhave to know the semantics of the data you are trying to model.
    SQL is a language based on syntax, not semantics.

    For example, if a NULL is being used for a missing diagnosis in a medical record,
    you know that each patient will probably have a different disease when the NULLs are resolved.
    Putting the NULLs in one group would make sense if you wanted to consider unprocessed diagnosis reports
    as one group in a summary.
    Putting each NULL in its own group would make sense if you wanted to consider each unprocessed diagnosis
    report as an action item for treatment of the relevant class of diseases.
    Another example was a traffic ticket databasde that used NULL for a missing auto tag.
    Obviously, there is more than one car without a tag in the database.
    The general scheme for getting separate groups for each NULL is straightforward:

        SELECT x, ..
            FROM Table1
          WHERE x IS NOT NULL
          GROUP BY x
        UNION ALL
        SELECT x, ..
            FROM Table1
          WHERE x IS NULL;

    There will also be cases, such as the traffic tickets,
    where you can use another GROUP BY clause to form groups where the principal grouping columns are NULL.
    For example, the VIN (Vehicle Identification Number) is taken when the car is missing a tag,
    and it would provide a grouping column.

