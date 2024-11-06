#create a test for no inputs
if [$# -eq 0] then;
  echo "Usage: gen_m3u.sh file file ..." >&2
  exit 1
fi

#begin file
echo "#EXTM3U"
for file in "$@"; do
  #put invalid file check here?

  duration=$  #soxi D
  title=$ #soxi -a
  artist=$soxi-a

  echo "#EXTINF:${duration},${title} - ${artist}"
  echo "$(realpath "$file")"
done

#I spent like 3 hours on VIM struggling to write this, and then accidentally did :qa!
#and deleted everything, so I decided to write it here and git clone it to the VM
