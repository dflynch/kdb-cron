\d .cron

tab:enlist`func`time!(();0Wp) / accept functions or function names, guard against type matching

upd:`.cron.tab upsert
add:{upd(x;gtime y)}          / accept local time, but convert to UTC before scheduling

run:{[t;i]                    / run function at (i)ndex
  f:tab[i;`func];               / grab the function to run
  .[`.cron.tab;();_;i];         / delete entry
  r:value f,ltime t;            / run function with local time
  if[not null r;upd(f;t+r)];    / if an interval is returned, reschedule
  }

ts:{x run/:reverse where x>=tab`time;x} / run functions past due 

\
Usage:

  Extend built-in timer functionality to support multiple jobs running on 
  separate schedules with dynamic intervals. A timer function should return 
  the interval between executions; to stop, return null.

  Assign .cron.ts to .z.ts and start the timer.

  f:{show x;};
  g:{show y;x};
  h:{show x;00:01};
  i:{show x;24:00};
  j:{if[z<x;show z;:y]};

  .cron.add[`f;t]                       / run at 't'
  .cron.add[(`g;s);.z.P]                / run every 's'
  .cron.add[`h;.z.P]                    / run every minute
  .cron.add[`i;08:00+.z.D+.z.P>08:00]   / run every morning at 08:00 AM
  .cron.add[(`j;.z.D+12:00;00:05);.z.P] / run every 5 minutes until noon today
