#!/bin/bash

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
SOURCE_URL=https://picsum.photos/2560/1440
LOCAL_FILENAME=background

# find the redirecting destination
wget --content-disposition -O "$SCRIPT_PATH/$LOCAL_FILENAME" $SOURCE_URL 2> "$SCRIPT_PATH/wgetLog"

# Extract the id of the file on Picsum
ID=$(awk '/Location:/{print $2}' "$SCRIPT_PATH/wgetLog" | sed -r 's#^\/id\/([0-9]*)\/.*$#\1#g')
# echo $ID

# make the url and grab the image info
INFO_URL="https://picsum.photos/id/$ID/info"
# echo $INFO_URL > $SCRIPT_PATH/1

IMAGE_INFO=$(curl -X GET "$INFO_URL")
# echo $IMAGE_INFO > $SCRIPT_PATH/2

#PHOTOGRAPHER=$(echo "$IMAGE_INFO" | grep -Po '"author":.*?[^\\]"')
PHOTOGRAPHER=$(echo $IMAGE_INFO | grep -Po '"author":.*?[^\\]"' | awk 'BEGIN{FS=":"}  {print $2}' | tr -d '"')
# echo $PHOTOGRAPHER >> $SCRIPT_PATH/1

# current date
# DATE=`date`

# write the name of photographer on the image
convert -font helvetica -pointsize 25 -fill yellow -draw "text 2000,1390 'Photo by: $PHOTOGRAPHER on Unsplash'" "$SCRIPT_PATH/$LOCAL_FILENAME" "$SCRIPT_PATH/$LOCAL_FILENAME"

# change desktop background
gsettings set org.cinnamon.desktop.background picture-uri "file://$SCRIPT_PATH/$LOCAL_FILENAME"
