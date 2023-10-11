#!/bin/bash
echo "!!!!!!!!!!!"
echo "Warning this will TRUNCATE the following table"
echo "Users, Rooms, Courses, Registers, Schedules"
echo ""

host_env=`hostname`
if [ $host_env == "wae2" ] 
then
	db="assignment_production"
else
	db="assignment_development"
fi

echo "Press "Y" to continue, press any key to EXIT"
read input
if [ $input == "Y" -o $input == "y" ]; then

	TRUNCATE Users,Registers,Courses,Schedules RESTART IDENTITY;

	echo $db
	psql -d $db < insert_users.sql
	psql -d $db < insert_coures.sql
	psql -d $db < insert_rooms.sql
	psql -d $db < insert_schedules.sql
	psql -d $db < insert_registers.sql


fi

echo "Successfuly mocking data"