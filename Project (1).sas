/* Read data from file */
proc import datafile="/home/u49723201/Project/MOVIES.xlsx" out=MOVIES1 dbms=xlsx replace;
getnames=yes;
run;

proc print data=MOVIES1;
run;

data MOVIES;
set MOVIES1;
LOGTDOMGROSS = log(TDOMGROSS);
/* COUNTRY has three levels. Define two indicator variables: USA and ENGNONUSA*/
if COUNTRY=1 then USA=1; else USA=0;
if COUNTRY=2 then ENGNONUSA=1; else ENGNONUSA=0;
/* indicator variables for genre*/
if GENRE=1 then action=1; else action=0;
if GENRE=2 then drama=1; else drama=0;
if GENRE=3 then childrens=1; else childrens=0;
if GENRE=4 then comedy=1; else comedy=0;
if GENRE=5 then documentary=1; else documentary=0;
if GENRE=6 then thriller=1; else thriller=0;
if GENRE=7 then horror=1; else horror=0;
/* indicator variables for MPAA*/
if MPAA=1 then G=1; else G=0;
if MPAA=2 then PG=1; else PG=0;
if MPAA=3 then PG13=1; else PG13=0;
if MPAA=4 then R=1; else R=0;
if MPAA=5 then NC17=1; else NC17=0;

run;

proc print data=MOVIES;
run;


/* Summarize data */
proc univariate data=MOVIES normaltest plot; 
var LOGTDOMGROSS;
run;

/*Some Scatterplots */
proc sgplot data=MOVIES;
scatter x=GENRE y=LOGTDOMGROSS;
run;  /* No visual pattern */

proc sgplot data=MOVIES;
scatter x=MPAA y=LOGTDOMGROSS;
run;  /* No visual pattern */

proc sgplot data=MOVIES;
scatter x=COUNTRY y=LOGTDOMGROSS;
run;  /* No visual pattern */

proc sgplot data=MOVIES;
scatter x=SUMMER y=LOGTDOMGROSS;
run;  /*It appears that summer releases may result in higher gross revenue.*/

proc sgplot data=MOVIES;
scatter x=SEQUEL y=LOGTDOMGROSS;
run;  /*It appears that sequels may result in higher gross revenue.*/


/*Stepwise regression on all variables*/
proc reg data=MOVIES;
model LOGTDOMGROSS = BACTOR TDACTOR CHRISTMAS HOLIDAY SUMMER SEQUEL {USA ENGNONUSA} {action drama childrens comedy documentary thriller} {G PG PG13 R NC17} / selection=stepwise;
run;


/*Backward elimination on all variables*/
proc reg data=MOVIES;
model LOGTDOMGROSS = BACTOR TDACTOR CHRISTMAS HOLIDAY SUMMER SEQUEL {USA ENGNONUSA} {action drama childrens comedy documentary thriller} {G PG PG13 R NC17} / selection=backward;
run;

/*Linear regression after removing variables from backward elimination*/
proc reg data=MOVIES;
model LOGTDOMGROSS = BACTOR TDACTOR SUMMER {action drama childrens comedy documentary thriller horror} {G PG PG13 R NC17};
run;


ODS TRACE OFF;
ODS GRAPHICS OFF;
ODS PDF CLOSE;

