#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPO_GOALS
do
#skip first row
  if [[ $YEAR != year ]]
  then
    #get existing team id from teams table
    OLD_WINNER="$($PSQL "select team_id from teams where name='$WINNER'")"
    OLD_OPPONENT="$($PSQL "select team_id from teams where name='$OPPONENT'")"
    #if not found winner insert winner name
    if [[ -z $OLD_WINNER ]]
    then
    INSERT_WINNER="$($PSQL "insert into teams(name) values('$WINNER')")"
    OLD_WINNER="$($PSQL "select team_id from teams where name='$WINNER'")"

    fi
    #insert team opponent if not found
    if [[ -z $OLD_OPPONENT ]]
    then
    INSERT_OPPONENT="$($PSQL "insert into teams(name) values('$OPPONENT')")"
    OLD_OPPONENT="$($PSQL "select team_id from teams where name='$OPPONENT'")"

    fi
    #insert data in gammes table
    INSERT_GAME="$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($YEAR,'$ROUND',$OLD_WINNER,$OLD_OPPONENT,$WINNER_GOALS,$OPPO_GOALS)")"
  fi
done