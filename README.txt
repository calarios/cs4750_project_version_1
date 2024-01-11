main.dart:

Imports all dart files.
Makes the main menu of all of the options for 4 different set timers.

------------------------------------------------
Timers.dart:

The basis for the remaining 3 timers.
Allows input of individual hour, minute and seconds for how long the timer should be
2 tabs for the user to use, 1 for work session, other for break

Page includes StartTimer, StopTimer, and ResetTimer.
Alarm method is made for the mp3 file
stopAlarm method created.

additional methods include buildInput for the input fields
and formatDuration for hours minutes and remaining seconds

------------------------------------------------
twentyRule.dart:

Imported from Timers.dart, changed so that there's
no user input and set both clocks based off the 20/20/20 rule.

outside of minor text, no other edit was made

------------------------------------------------
Stopwatch.dart:

Imported from Timers.dart, changed it so that there's
only 1 tab. Instead of counting down, the program counts up
similar to a stopwatch. Outside of what was mentioned
no other edits was made.

------------------------------------------------
alarmTime.dart:

Imported from Timers.dart, changed it so that the clock
coninuously is being updated and when the user sets alarm time,
then the alarm goes off at that time, no other edits was made.