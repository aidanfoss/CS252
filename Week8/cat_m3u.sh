#!/bin/bash
#check if no inputs, display usage
if [ $# -eq 0 ]; then
    echo "Usage: cat_m3u.sh file file ..." >&2
    exit 1
fi

for file in "$@"; do
  #check for invalid inputs
  if [[ ! -f "$file" ]] then
    echo "Couldnt read $file, skipping" >&2
    continue
  fi

  #vars
  totalDuration=0;

  #check if line is readable, including any issues with newline chars at the end
  while IFS= read -r line || [[ -n "$line" ]]; do
    #use bash rematch to apply values to variables
    if [[ "$line" == *#EXTINF* ]]; then
     #seconds=$(echo "$line" | tr -d -c 0-9)
      seconds=$(echo "$line" | awk -F'[,:]' '/#EXTINF/{print $2}')
      trackinfo=$(echo "$line" | awk -F, '{print $2}')

      (( totalDuration += seconds ))
      
      if ((seconds > 3600)); then
        printf "%3d:%02d:%02d  %s\n" $((seconds/3600)) $((seconds%3600/60)) $((seconds%60)) "$trackinfo"
      else
        printf "%5d:%02d  %s\n" $((seconds/60)) $((seconds%60)) "$trackinfo"
      fi
    fi
    done < "$file"

    printf "========  ==================================================\n"
    
    if (( totalDuration >= 3600)); then
      printf "%3d:%02d:%02d  %s\n" $((totalDuration/3600)) $((totalDuration%3600/60)) $((totalDuration%60)) "$(basename "$file")"
    else
      printf "%5d:%02d  %s\n" $((totalDuration/60)) $((totalDuration%60)) "$(basename "$file")"
    fi
done
