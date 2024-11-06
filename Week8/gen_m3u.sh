#create a test for no inputs
if [$# -eq 0] then;
  echo "Usage: gen_m3u.sh file file ..." >&2
  exit 1
fi

#begin file
echo "#EXTM3U"
for file in "$@"; do
  #put invalid file check here?

  duration=$(soxi -D "$file" | awk '{print int($1)}')
  title=$(soxi -a "$file" | grep -i 'title=' | sed 's/.*title=//' || echo "untitled")
  artist=$(soxi -a "$file" | grep -i 'artist=' | sed 's/.*artist=//' || echo "unknown artist")

  echo "#EXTINF:${duration},${title} - ${artist}"
  echo "$(realpath "$file")"
done

#I spent like 3 hours on VIM struggling to write this, and then accidentally did :qa!
#and deleted everything, so I decided to write it here and git clone it to the VM
