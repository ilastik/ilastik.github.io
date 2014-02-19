for i in *.png; do
    convert $i -resize 300 -quality 70 thumb/`basename $i .png`.jpg
done;

for i in *.jpg; do
    convert $i -resize 300 -quality 70 thumb/$i
done;
