#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Check if input is atomic number
if [[ $1 =~ ^[0-9]+$ ]]
then
  RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
    FROM elements
    JOIN properties USING(atomic_number)
    JOIN types USING(type_id)
    WHERE atomic_number=$1;")
else
  # Check if input is symbol or name
  RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
    FROM elements
    JOIN properties USING(atomic_number)
    JOIN types USING(type_id)
    WHERE symbol='$1' OR name='$1';")
fi

# If no result found
if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
else
  IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELT BOIL <<< "$RESULT"
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
fi
