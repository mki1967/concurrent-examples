#!/bin/bash

FILE=${1? 'parameter ${1} should be the name of the travel history file'}

mapfile <  <(sort <${FILE} -n -k 1) TAB

TAB_LENGTH=${#TAB[@]}

# echo "TAB_LENGTH = "${TAB_LENGTH} ## TEST

read -a ARGS < <(echo ${TAB[0]});

if (( ARGS[0] != -1 ));
then
  echo 'The first line should start with -1 and then contain display parameters';
  exit -1;
fi;

declare -i TRAVELERS=${ARGS[1]:? 'number of travelers missing'}
declare -i WIDTH=${ARGS[2]:? 'display width missing'}
declare -i HEIGHT=${ARGS[3]:? 'display height missing'}
declare -a DISPLAY
declare -a LAST_X
declare -a LAST_Y
declare -a COVERED_BY
declare -a COVERS
declare -a SYMBOL
declare -i START_STEP=1 # The first step in 'travel history'

# init empty DISPLAY

function d_idx {  # index in DISPLAY for arguments: x y - coordimates
  X=${1}
  Y=${2}
  echo $(( Y * WIDTH + X )) 
  # echo $X $Y
}


function display_reset { # reset the display
  DISPLAY[$(d_idx WIDTH HEIGHT)]=${TRAVELERS} # space on the 'hidden' position
  # clean screen
  for (( Y=0; Y < HEIGHT; Y++ )) 
  do
    for (( X=0; X < WIDTH; X++ ))
    do
      DISPLAY[$(d_idx $X $Y)]=${TRAVELERS}; # ${TRAVELERS} is ID of empty space
    done;
  done;
  
  # Initially, all the travelers are on the 'hidden' position
  for (( ID=0; ID <= TRAVELERS; ID++ ))
  do
    COVERS[${ID}]=${TRAVELERS};
    COVERED_BY[${ID}]=${TRAVELERS};
    LAST_X[${ID}]=${WIDTH};
    LAST_Y[${ID}]=${HEIGHT};
    SYMBOL_ID[${ID}]='?';
  done;    
  SYMBOL_ID[${TRAVELERS}]='.' # ${TRAVELERS} is ID of empty space
}

function h_line {
    echo -n '+'
    for (( X=0; X < WIDTH; X++ ))
    do
      echo -n "--+";
    done;
    echo
}

H_LINE=$(h_line);

function line_y {
    Y=${1}
    echo -n '|'
    for (( X=0; X < WIDTH; X++ ))
    do
      echo -n "${SYMBOL_ID[${DISPLAY[$(d_idx $X $Y)]}]} |";
    done;
    echo
}

declare -a LINE_Y;

function display_print { # print current display
  for (( Y=0; Y < HEIGHT; Y++ )) 
  do
    LINE_Y[${Y}]=$(line_y ${Y});
  done;

  clear;
  echo "STEP = ${STEP}  TIME = ${ARGS[0]}" 

  for (( Y=0; Y < HEIGHT; Y++ )) 
  do
    echo ${H_LINE};
    echo ${LINE_Y[${Y}]};
  done;
  echo ${H_LINE};
}


# exit #####

function display_update_by_step { # $1 is step number
  STEP=${1}
  read -a ARGS < <(echo ${TAB[${STEP}]});
  # echo ${!ar[@]} ${ar[@]};  ## TEST
  # echo ${ARGS[@]};
  # echo "STEP = ${STEP}  TIME = ${ARGS[0]}" 
  
  ID=${ARGS[1]}
  X=${ARGS[2]}
  Y=${ARGS[3]}
  SYMBOL=${ARGS[4]}
  
  SYMBOL_ID[${ID}]=${SYMBOL}
  if (( ${COVERS[${ID}]} == ${TRAVELERS} ))
  then
    DISPLAY[$(d_idx ${LAST_X[${ID}]} ${LAST_Y[${ID}]})]=${COVERED_BY[${ID}]} # uncover previous position
  fi
  COVERS[${COVERS[${ID}]}]=${COVERED_BY[${COVERED_BY[${ID}]}]}
  COVERED_BY[${COVERED_BY[${ID}]}]=${COVERS[${COVERS[${ID}]}]};
  
  # new 'last' coordinates
  LAST_X[${ID}]=${X} 
  LAST_Y[${ID}]=${Y}
  # cover new position:
  COVERED_BY[${ID}]=${DISPLAY[$(d_idx ${LAST_X[${ID}]} ${LAST_Y[${ID}]})]}
  COVERS[${COVERED_BY[${ID}]}]=${ID}
  COVERS[${ID}]=${TRAVELERS} # ${ID} is on top
  DISPLAY[$(d_idx ${LAST_X[${ID}]} ${LAST_Y[${ID}]})]=${ID} # ocupy new position  
}


# ACTION !

clear;
echo "START"
display_reset; # test reset
display_print; # test display printing
read  ;

for (( STEP=START_STEP; STEP< TAB_LENGTH; STEP++ ))
do
  display_update_by_step ${STEP} ;
  display_print ;
  if (( DELTA > 0 ));
  then
    DELTA=$(( DELTA - 1 ))
  else
    echo -n "STEPS? " 
    read DELTA
  fi;
done

