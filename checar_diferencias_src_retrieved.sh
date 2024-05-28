#!/bin/bash


IFS=$'\n'

##$ cambiar estos paths
## SRC es dondes guarden los packages.xml del script para generar los xml
SRC_PATH="/home/dhuerta/azusgb01/src/"
## RETRIEVED es el path donde descomprimimos los packages que bajamos del workbench
RETRIEVED_PATH="/mnt/c/Users/kblq432/Downloads/retrieved/unpackaged"

echo "src $SRC_PATH"
echo "retrieved $RETRIEVED_PATH"

for FOLDER in  $(ls $SRC_PATH);
do
  echo -e "\n\n============== Checking  $FOLDER ... ==============="

  for file in $(ls "$SRC_PATH/$FOLDER");
     do
     #echo "CURRENT $SRC_PATH / $FOLDER"
     item=$( echo $file | rev | cut -f 2- -d "." | rev );  ### se hace de esa manera para evitar el problema que genera el que usen puntos en los nombres de archivo
     ls $RETRIEVED_PATH/$FOLDER | grep -q $item || echo "$item  <<< FAILED ";  ## comparas el contenido de SRC con los archivos bajados del worbench
  done;

done

