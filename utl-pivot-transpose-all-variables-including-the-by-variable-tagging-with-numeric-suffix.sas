%let pgm =utl-pivot-transpose-all-variables-including-the-by-variable-tagging-with-numeric-suffix;

%stop_submission;

Pivot transpose all variables including the by variable tagging with numeric suffix

 SOLUTIONS

    1 sas transpose macro
      Arthur Tabachneck

    2 sas base
      ksharp
      https://communities.sas.com/t5/user/viewprofilepage/user-id/18408

github
https://tinyurl.com/34s4c9xy
https://github.com/rogerjdeangelis/utl-pivot-transpose-all-variables-including-the-by-variable-tagging-with-numeric-suffix

communities.sas
https://tinyurl.com/4t4ndvw8
https://communities.sas.com/t5/SAS-Programming/Year-by-horizontal-data/m-p/790503#M253108


/**************************************************************************************************************************/
/*     INPUT                 |        PROCESS                 |                  OUTPUT                                   */
/*     ====                  |        =======                 |                  ======                                   */
/*  WORK.HAVE total obs=4    | 1 TRANSPOSE MACRO              | year_ name_ sales_   year_ name_ sales_                   */
/*                           | =================              |  2001 2001   2001     2002 2002   2002                    */
/*  year  name sales  id     |                                |                                                           */
/*                           | %utl_transpose(                |  2001 jack   2000     2002 jack   4000                    */
/*  2001  john  1000 john    |    data=have                   |  2001 john   1000     2002 john   3000                    */
/*  2001  jack  2000 jack    |    ,out=want                   |                                                           */
/*  2002  john  3000 john    |    ,sort=yes                   |                                                           */
/*  2002  jack  4000 jack    |    ,by=name                    |                                                           */
/*                           |    ,id=year                    |                                                           */
/*                           |    ,delimiter=_                |                                                           */
/*  data have;               |    ,var= year name sales)      |                                                           */
/*  input year name $ sales; |                                |                                                           */
/*  id=name;                 |--------------------------------------------------------------------------------------------*/
/*  cards4;                  | 2 BASE SAS                     | year2001 name2001 sales2001 year2002 name2002 sales2002   */
/*  2001 john 1000           | ==========                     |                                                           */
/*  2001 jack 2000           |                                |  2001     jack      2000     2002     jack      4000      */
/*  2002 john 3000           | proc sort data=have;           |  2001     john      1000     2002     john      3000      */
/*  2002 jack 4000           |  by name;                      |                                                           */
/*  ;;;;                     | run;quit;                      |                                                           */
/*  run;quit;                |                                |                                                           */
/*                           | proc sql noprint;              |                                                           */
/*                           | select                         |                                                           */
/*                           |  distinct catt(                |                                                           */
/*                           |    'have(rename=(year=year'    |                                                           */
/*                           |    ,year                       |                                                           */
/*                           |    ,' name=name'               |                                                           */
/*                           |    ,year                       |                                                           */
/*                           |    ,' sales=sales'             |                                                           */
/*                           |    ,year,') where=(year'       |                                                           */
/*                           |    ,year                       |                                                           */
/*                           |    ,'='                        |                                                           */
/*                           |    ,year                       |                                                           */
/*                           |    ,'))')                      |                                                           */
/*                           |  into                          |                                                           */
/*                           |    : merge separated by ' '    |                                                           */
/*                           |  from have ;                   |                                                           */
/*                           | quit;                          |                                                           */
/*                           |                                |                                                           */
/*                           | data want;                     |                                                           */
/*                           |  merge &merge. ;               |                                                           */
/*                           |  by id;                        |                                                           */
/*                           |  drop id;                      |                                                           */
/*                           | run;                           |                                                           */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

data have;
input year name $ sales;
id=name;
cards4;
2001 john 1000
2001 jack 2000
2002 john 3000
2002 jack 4000
;;;;
run;quit;

/**************************************************************************************************************************/
/*  WORK.HAVE total obs=4                                                                                                 */
/*                                                                                                                        */
/*  year  name sales  id                                                                                                  */
/*                                                                                                                        */
/*  2001  john  1000 john                                                                                                 */
/*  2001  jack  2000 jack                                                                                                 */
/*  2002  john  3000 john                                                                                                 */
/*  2002  jack  4000 jack                                                                                                 */
/**************************************************************************************************************************/

/*   _
/ | | |_ _ __ __ _ _ __  ___ _ __   ___  ___  ___  _ __ ___   __ _  ___ _ __ ___
| | | __| `__/ _` | `_ \/ __| `_ \ / _ \/ __|/ _ \| `_ ` _ \ / _` |/ __| `__/ _ \
| | | |_| | | (_| | | | \__ \ |_) | (_) \__ \  __/| | | | | | (_| | (__| | | (_) |
|_|  \__|_|  \__,_|_| |_|___/ .__/ \___/|___/\___||_| |_| |_|\__,_|\___|_|  \___/
                            |_|
*/

%utl_transpose(
   data=have
   ,out=want
   ,sort=yes
   ,by=name
   ,id=year
   ,delimiter=_
   ,var= year name sales)

/**************************************************************************************************************************/
/* WORK.WANT total obs=2                                                                                                  */
/*  year_    name_    sales_    year_    name_    sales_                                                                  */
/*   2001    2001      2001      2002    2002      2002                                                                   */
/*                                                                                                                        */
/*   2001    jack      2000      2002    jack      4000                                                                   */
/*   2001    john      1000      2002    john      3000                                                                   */
/**************************************************************************************************************************/

/*___    _
|___ \  | |__   __ _ ___  ___   ___  __ _ ___
  __) | | `_ \ / _` / __|/ _ \ / __|/ _` / __|
 / __/  | |_) | (_| \__ \  __/ \__ \ (_| \__ \
|_____| |_.__/ \__,_|___/\___| |___/\__,_|___/

*/

proc sort data=have;
 by name;
run;quit;

proc sql noprint;
select
 distinct catt(
   'have(rename=(year=year'
   ,year
   ,' name=name'
   ,year
   ,' sales=sales'
   ,year,') where=(year'
   ,year
   ,'='
   ,year
   ,'))')
 into
   : merge separated by ' '
 from have ;
quit;

data want;
 merge &merge. ;
 by id;
 drop id;
run;


/**************************************************************************************************************************/
/*  WORK.WANT total obs=2                                                                                                 */
/*                                                                                                                        */
/*   year2001    name2001    sales2001    year2002    name2002    sales2002                                               */
/*                                                                                                                        */
/*     2001        jack         2000        2002        jack         4000                                                 */
/*     2001        john         1000        2002        john         3000                                                 */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
