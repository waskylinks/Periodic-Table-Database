#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi
# Handle atomic number look up
if [[ $1 =~ ^[0-9]+$ ]]
then
  RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
    FROM elements
    JOIN properties USING(atomic_number)
    JOIN types USING(type_id)
    WHERE atomic_number=$1;")
fi
# Handle name and symbol lookup
if [[ -z $RESULT ]]
then
  RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
    FROM elements
    JOIN properties USING(atomic_number)
    JOIN types USING(type_id)
    WHERE symbol='$1' OR name='$1';")
fi
