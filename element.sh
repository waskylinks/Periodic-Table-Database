#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# If no argument is provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

ARG=$1

# Query the database by atomic number or by symbol/name
if [[ $ARG =~ ^[0-9]+$ ]]
then
  # Search by atomic_number
  ELEMENT_DATA=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
                        FROM elements AS e
                        JOIN properties AS p USING(atomic_number)
                        JOIN types AS t USING(type_id)
                        WHERE e.atomic_number = $ARG;")
else
  # Search by symbol or name (case-insensitive)
  ELEMENT_DATA=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
                        FROM elements AS e
                        JOIN properties AS p USING(atomic_number)
                        JOIN types AS t USING(type_id)
                        WHERE e.symbol ILIKE '$ARG' OR e.name ILIKE '$ARG';")
fi

# If no element was found
if [[ -z $ELEMENT_DATA ]]
then
  echo "I could not find that element in the database."
  exit
fi

# Read the data into variables
IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING BOILING <<< "$ELEMENT_DATA"

# Output the element information
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
