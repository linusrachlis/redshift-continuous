#!/bin/bash

# Taken inspiration from
# https://github.com/linusrachlis/redshift-continuous/blob/master/redshift-continuous.sh,
# except i've prettied up the script a bit, and added a third phase,
# bedtime.  That's copying f.lux's recent update.
#
# -- Paul, 4/Feb/2017
set -eu

prog=$(basename $0)

echo "[$prog] --- starting at $(date)"

# 5700K is daylight, and the Redshift default.
DAYTIME=6500 # No filter, RGB monitor white point.
# 3400K is like halogen
EVENING=3400
# 1900K is candlelight
BEDTIME=1900

arith_exec () {
    $(echo "scale=1; $1" | bc)
}

set_raw_temp () {
    TEMP=$1
    DISPLAY=:0 redshift -O $TEMP
}

set_named_temp () {
    NAME=$1
    TEMP=${!NAME}
    echo "[$prog] Setting to $NAME ${TEMP}K colour temperature."
    set_raw_temp $TEMP
}

temp_tween() {
    # Call with arguments:
    #    temp_tween $OLD $NEW
    OLD_NAME=$1
    NEW_NAME=$2
    OLD=${!1}
    NEW=${!2}
    echo "[$prog] Tween from $OLD_NAME -> $NEW_NAME (${OLD}K to ${NEW}K)"

    current_minute=$(date +%M)
    minute_ratio=$(arith_exec "$current_minute/60")

    delta=$(arith_exec "($NEW - $OLD) * $minute_ratio")
    new_kelvin=$(printf "%1.0f" $(arith_exec "$OLD + $delta"))

    echo "[$prog] current_minute = $current_minute, minute_ratio = $minute_ratio, new_kelvin = $new_kelvin"
    set_raw_temp $new_kelvin
}

daytime() {
    set_named_temp "DAYTIME"
}

evening() {
    set_named_temp "EVENING"
}

bedtime() {
    set_named_temp "BEDTIME"
}

daytime_tween() {
    # From bedtime -> daytime
    temp_tween "BEDTIME" "DAYTIME"
}

evening_tween() {
    # From day -> evening
    temp_tween "DAYTIME" "EVENING"
}

bedtime_tween() {
    # From evening -> bedtime
    temp_tween "EVENING" "BEDTIME"
}

case $(date +%H) in
  '22' ) bedtime_tween ;;
  '23' ) ;&
  '00' ) ;&
  '01' ) ;&
  '02' ) ;&
  '03' ) ;&
  '04' ) ;&
  '05' ) ;&
  '06' ) bedtime ;;
  '07' ) daytime_tween ;;
  '08' ) ;&
  '09' ) ;&
  '10' ) ;&
  '11' ) ;&
  '12' ) ;&
  '13' ) ;&
  '14' ) ;&
  '15' ) ;&
  '16' ) ;&
  '17' ) ;&
  '18' ) ;&
  '19' ) daytime ;;
  '20' ) evening_tween ;;
  '21' ) evening ;;
esac
