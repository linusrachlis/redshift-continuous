#!/bin/bash

echo '---------------------------'
echo 'starting redshift at '`date`

night() {
  DISPLAY=:0 redshift -O 5000
  echo 'setting night'
}

day() {
  DISPLAY=:0 redshift -O 6500
  echo 'setting day'
}

morning_tween() {
  echo 'morning_tween'
  minute=`date +%M`
  echo "minute = $minute"
  minute_ratio=`php -r "echo $minute / 60;"`
  echo "minute_ratio = $minute_ratio"
  increase_kelvin_by=`php -r "echo 1500 * $minute_ratio;"`
  new_kelvin=`php -r "echo 5000 + $increase_kelvin_by;"`
  DISPLAY=:0 redshift -O $new_kelvin
  echo "setting to $new_kelvin"
}

evening_tween() {
  echo 'evening_tween'
  minute=`date +%M`
  echo "minute = $minute"
  minute_ratio=`php -r "echo $minute / 60;"`
  echo "minute_ratio = $minute_ratio"
  reduce_kelvin_by=`php -r "echo 1500 * $minute_ratio;"`
  new_kelvin=`php -r "echo 6500 - $reduce_kelvin_by;"`
  DISPLAY=:0 redshift -O $new_kelvin
  echo "setting to $new_kelvin"
}

case `date +%H` in
  '22' ) ;&
  '23' ) ;&
  '00' ) ;&
  '01' ) ;&
  '02' ) ;&
  '03' ) ;&
  '04' ) ;&
  '05' ) ;&
  '06' ) night ;;
  '07' ) morning_tween ;;
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
  '19' ) ;&
  '20' ) day ;;
  '21' ) evening_tween ;;
esac
