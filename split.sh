filename="CASINO_DATA.csv"
file_prefix="CASINO_DATA_"

split -l 10000 $filename $file_prefix

for i in $(ls | grep -v csv); do 
  if [ $i != "$file_prefix"aa ] && [ $i != 'split.sh' ]; then
    head -n1 $filename | cat - $i > "$i.tmp" && mv "$i.tmp" "$i.csv" && rm $i  
  fi
  if [ $i == "$file_prefix"aa ]; then
    mv $i "$i.csv"
  fi
done

