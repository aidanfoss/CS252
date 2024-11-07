#!/bin/bash
#create a test for no inputs
if [[ $# -eq 0 ]]; then
  echo "Usage: gen_m3u.sh file file ..." >&2
  exit 1
fi

#begin file
printf "#EXTM3U"
for file in "$@"; do
  #put invalid file check here?
  if [[ ! -f "$file" ]]; then
    echo "Couldn't process $file" >&2
    continue
  fi

  duration=$(soxi -D "$file" | awk '{print int($1)}')
  title=$(soxi -a "$file" | grep -i 'title=' | sed 's/.*title=//')
  artist=$(soxi -a "$file" | grep -i 'artist=' | sed 's/.*artist=//')

  title=${title:-"Title:Untitled"}
  artist=${artist:-"Artist:Unknown Artist"}

  echo "#EXTINF:${duration},${title} - ${artist}"
  echo "$(realpath "$file")"
done

