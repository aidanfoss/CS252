#check if no inputs, display usage
if [ $# -eq 0 ]; then
    echo "Usage: cat_m3u.sh file file ..." >&2
    exit 1
fi

for file in "$@"; do
  #check for invalid inputs

  #vars
  totalDuration = 0;

  #check if line is readable, including any issues with newline chars at the end
  while IFS= read -r line || [[ -n "$line" ]]; do
    #use bash rematch to apply values to variables
    if [[ $line =~ ^#EXTINF:([0-9]+),(.*) ]]; then
      seconds="${BASH_REMATCH[1]}"
      trackinfo="${BASH_REMATCH[2]}"

      totalDuration = totalDuration + seconds
      #datetime formatted printf output
#you may assume that there will be no duration that exceeds 99 hours.
#In the above, “h” indicates the number of hours, “mm” indicates the number of minutes, and “ss” indicates
#the number of seconds, in a typical clock format: seconds are between 0 and 59 and always displayed as two
#digits, minutes are between 0 and 59 and are displayed as one digit if and only if the duration is less than
#ten minutes. hours are between 1 and 99 (because they are not displayed when 0) and are displayed as one
#digit if and only if the duration is less than ten hours.
      if ((total_seconds > 3600)); then
        printf "%8d:%02d  %s\n\n" $((total_seconds/3600)) $((total_seconds%3600/60)) $((total_seconds%60)) "$(basename "$file")"
      else
        printf "%8d:%02d:%02d  %s\n\n" $((total_seconds/3600)) $((total_seconds%3600/60)) $((total_seconds%60)) "$(basename "$file")"
      fi
    done < "$file"

    printf "======== ==================================================\n"
    if (( total_seconds >= 3600)); then
      printf "%8d:%02d:%02d  %s\n\n" $((total_seconds/3600)) $((total_seconds%3600/60)) $((total_seconds%60)) "$(basename "$file")"
    else
      printf "%8d:%02d  %s\n\n" $((total_seconds/60)) $((total_seconds%60)) "$(basename "$file")"
    fi
done
