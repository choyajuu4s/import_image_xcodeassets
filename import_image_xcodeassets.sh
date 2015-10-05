#!/bin/sh

create_imagesets() {
	for file in * ; do
		if [ -f $file ] ; then
			file_base=${file%.*}
			imageset_base=${file_base%~iphone}
			imageset_base=${file_base%~ipad}
			imageset_base=${imageset_base%@2x}
			imageset_base=${imageset_base%@3x}
			dir=$imageset_base".imageset"
			mkdir -p $dir
			mv $file $dir
		fi
	done
}

create_contents() {
	for dir in * ; do
		if [ -d $dir ] ; then
			imageset_base=${dir%.imageset}
			file1=$imageset_base".png"
			file2=$imageset_base"@2x.png"
			file5=$imageset_base"@3x.png"
			file3=$imageset_base"~ipad.png"
			file4=$imageset_base"@2x~ipad.png"
			file6=$imageset_base"@3x~ipad.png"
			cat <<- END_JSON > $dir/Contents.json
			{
			  "images" : [
			    {
			      "idiom" : "universal",
			      "scale" : "1x",
			      "filename" : "$file1"
			    },
			    {
			      "idiom" : "universal",
			      "scale" : "2x",
			      "filename" : "$file2"
			    },
			    {
			      "idiom" : "universal",
			      "scale" : "3x",
			      "filename" : "$file5"
			    }
END_JSON

      if [[ -f $dir/$file4 ]];then
      cat <<- END_JSON >> $dir/Contents.json
			    ,{
			      "idiom" : "ipad",
			      "scale" : "1x",
			      "filename" : "$file3"
			    },
			    {
			      "idiom" : "ipad",
			      "scale" : "2x",
			      "filename" : "$file4"
			    },
			    {
			      "idiom" : "ipad",
			      "scale" : "3x",
			      "filename" : "$file6"
			    }
END_JSON
      fi

      cat <<- END_JSON >> $dir/Contents.json
			  ],
			  "info" : {
			    "version" : 1,
			    "author" : "xcode"
			  }
			}
END_JSON
		fi
	done
}

create_imagesets
create_contents
