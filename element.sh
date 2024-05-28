# !/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if ! [[ $1 =~ ^[0-9]+$ ]]
  then
    # check if symbol
    if ! [[ $1 =~ ^[A-Z][a-z]?$ ]]
    then
      # if not symbol
      # search with name
      USER_ATOMIC_NAME=$1
      ELEMENT_TUPLE=$($PSQL "SELECT * FROM elements WHERE name = '$USER_ATOMIC_NAME';")
    else
      USER_ATOMIC_SYMBOL=$1
      ELEMENT_TUPLE=$($PSQL "SELECT * FROM elements WHERE symbol = '$USER_ATOMIC_SYMBOL';")
    fi

  else
    # search with atomic_number
    USER_ATOMIC_NUMBER=$1
    ELEMENT_TUPLE=$($PSQL "SELECT * FROM elements WHERE atomic_number = $USER_ATOMIC_NUMBER;")
  fi

  if [[ -z $ELEMENT_TUPLE ]]
  then
    echo "I could not find that element in the database."
  else
    echo $ELEMENT_TUPLE | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME
    do
      PROPERTIES_TUPLE=$($PSQL "SELECT * FROM properties INNER JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER;")
      echo $PROPERTIES_TUPLE | while read TYPE_ID BAR ATOMIC_NUMBER BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    done
  fi
fi