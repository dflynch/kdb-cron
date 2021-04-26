\l src/cron.q

f:{F+::1}
g:{G+::1;y;x}
h:{H+::1;00:01}
i:{I+::1;24:00}
j:{if[z<x;J+::1;:y]}

assert:{if[not x~y;'`$"expecting '",(-3!x),"' but found '",(-3!y),"'"]}

d:.z.D

assert[2]count value .cron.add[f;00:00+d]                   / pass by value
assert[3]count value .cron.add[`f;00:00+d]                  / pass by name
assert[4]count value .cron.add[(`g;00:01);00:01+d]          / minutely, parameterized
assert[5]count value .cron.add[`h;00:01+d]                  / minutely, hard-coded
assert[6]count value .cron.add[`i;00:10+d]                  / daily, first run today
assert[7]count value .cron.add[`i;00:10+d+1]                / daily, first run tomorrow
assert[8]count value .cron.add[(`j;00:20+d;00:01);00:15+d]  / minutely, from 00:15 until 00:20

p:00:00:01 / one second period

.cron.ts gtime d+00:00;                 / simulate tick at midnight
assert[2]F                              / expect f and `f  to execute once each
assert[6]count .cron.tab                / expect f and `f to be removed

.cron.ts each gtime d+p*1+til 300;      / simulate ticks between 00:00 and 00:05
assert[5]G                              / expect `g to execute 5 times
assert[5]H                              / expect `h to execute 5 times 
assert[6]count .cron.tab                / expect `g and `h to remain

.cron.ts each gtime d+p*301+til 300;    / simulate ticks between 00:05 and 00:10
assert[10]G                             / expect `g to execute 5 more times
assert[10]H                             / expect `h to execute 5 more times 
assert[1]I                              / expect `i to execute once
assert[6]count .cron.tab                / expect `i to remain

.cron.ts each gtime d+p*601+til 900;    / simulate ticks between 00:10 and 00:25
assert[25]G                             / expect `g to execute 15 more times
assert[25]H                             / expect `h to execute 15 more times 
assert[5]J                              / expect `j to execute 5 times 
assert[5]count .cron.tab                / expect `j to be removed

.cron.ts each gtime d+p*1501+til 85500; / simulate ticks between 00:25 and 00:10 the next day
assert[1450]G                           / expect `g to execute 1425 more times
assert[1450]H                           / expect `h to execute 1425 more times 
assert[3]I                              / expect `i to execute twice more
assert[5]count .cron.tab                / expect `i to remain
