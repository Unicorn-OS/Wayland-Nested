#!/bin/bash
#from: https://askubuntu.com/questions/956664/how-do-i-determine-which-is-the-current-users-de-through-cli-within-ssh-or-cron

# Determinate the subject user - $USR
if [ "$1" == "simple" ]; then
                USR="$(id -u)"
                OUTPUT="simple"
elif [ -z "${1}" ]; then
                USR="$(id -u)"
                OUTPUT="$2"
else
                USR="$1"
                OUTPUT="$2"
fi

[ "$USR" == "$(id -u)" ] && SUDO="" || SUDO="sudo"

# Get the most frequent value of any array - https://stackoverflow.com/a/43440769/6543935
get_frequent(){
    awk 'BEGIN{FS=" "} {for(i=1;i<=NF;i++) print $i}' | \
    awk '
      {
          n=++hsh[$1]
          if(n>max_occ){
             max_occ=n
             what=$1
          }else if(n==max_occ){
             if(what>$1)
                 what=$1
          }
      }
      END { print what }
    '
}

# Get the numbers of all $USR's processes
PS=`pgrep -U "${USR}"`

# Get the values of $XDG_CURRENT_DESKTOP, $GDMSESSION, $DESKTOP_SESSION from each "/proc/$ProcessNumber/environ" file
for PN in $PS; do
        XDG_CURRENT_DESKTOP+=$($SUDO sed -zne 's/^XDG_CURRENT_DESKTOP=//p' "/proc/$PN/environ" 2>/dev/null; echo " ")
        GDMSESSION+=$($SUDO sed -zne 's/^GDMSESSION=//p' "/proc/$PN/environ" 2>/dev/null; echo " ")
        DESKTOP_SESSION+=$($SUDO sed -zne 's/^DESKTOP_SESSION=//p' "/proc/$PN/environ" 2>/dev/null; echo " ")
done

# Get the most frequent name of any desctop environment
# This is a way to find the current DE when it is changed a little bit ago
XDG_CURRENT_DESKTOP=$(echo -e ${XDG_CURRENT_DESKTOP[@]} | get_frequent)
GDMSESSION=$(echo -e ${GDMSESSION[@]} | get_frequent)
DESKTOP_SESSION=$(echo -e ${DESKTOP_SESSION[@]} | get_frequent)

# Print the output values
if [ "$OUTPUT" == "simple" ]; then
        echo "${XDG_CURRENT_DESKTOP[@],,}" | sed 's/\-.*//'
else
        echo "user: $(id -n -u $USR)"
        echo "uid:  $USR"
        echo "XDG_CURRENT_DESKTOP: ${XDG_CURRENT_DESKTOP[@]^}"
        echo "GDMSESSION:          ${GDMSESSION[@]^}"
        echo "DESKTOP_SESSION:     ${DESKTOP_SESSION[@]^}"
fi
