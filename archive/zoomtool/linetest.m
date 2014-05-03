echo on

pause % try vertical cursor functions
clf
crsrmake('cursor','vertical',.5,':');

pause % move it
crsrmove('cursor',.3);

pause % move it again
crsrmove('cursor',.7);

pause % delete it
crsrdel('cursor');

pause % try cursor functions again
clf
crsrmake('cursor','vertical',.5,':');

pause % turn it off
crsroff('cursor');

pause % turn it on
crsron('cursor');

pause % move it
crsrmove('cursor',.3);

pause % move it again
crsrmove('cursor',.7);

pause % try horizontal cursor functions
clf
crsrmake('cursor','horizontal',.5,':');

pause % move it
crsrmove('cursor',.3);

pause % move it again
crsrmove('cursor',.7);

pause % delete it
crsrdel('cursor');

pause % try cursor functions again
clf
crsrmake('cursor','horizontal',.5,':');

pause % turn it off
crsroff('cursor');

pause % turn it on
crsron('cursor');

pause % move it
crsrmove('cursor',.3);

pause % move it again
crsrmove('cursor',.7);

