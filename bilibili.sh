echo "Bash Version: ${BASH_VERSION}"
echo "OS : $(uname)"
sleep 5

if [ "$(uname)" == "Darwin"]; then
	encoder="h264_videotoolbox"
elif ["$(expr substr $(uname -s) 1 5)" == "Linux"];then
	encoder="h264_nvenc"
elif [ "$(expr substr $(uname -s) 1 10) "=="MINGW32_NT"];then
	encoder="h264_nvenc"
fi

ffmpeg_transform_second() {
	CMD="ffmpeg -i ${1} -i ${2} -c:v ${encoder} -b:v 32000k ${3}"
	echo ${CMD}
    $($CMD)
}

process_working_dir() {
    w_d=$(ls $1)
	for path in ${w_d}
	do
	  if [ -d "${1}/${path}" ]; then
	    ffmpeg_transform_second "${1}/${path}/audio.m4s" "${1}/${path}/video.m4s" ${2} 
	  fi
	done
}

root="download"
OUTPUT_DIR="ConvertedVideo"
if [ ! -d ${OUTPUT_DIR} ]; then
	mkdir ${OUTPUT_DIR}
fi

if [ -d ${root} ]; then
  echo "${root} Directory Exists"
fi
CURRENT_DIR=$(ls "${root}")

for video_director in ${CURRENT_DIR}
do
    video_P=$(ls "${root}/${video_director}")
    for P in ${video_P}
	do
	    work_dir="${root}/${video_director}/$P"
		echo "Work ${work_dir}"
		output_filename="${OUTPUT_DIR}/${video_director}_${P}.mp4"
		if [ ! -f ${output_filename} ]; then
		    process_working_dir ${work_dir} "${OUTPUT_DIR}/${video_director}_${P}.mp4"
	    fi
    done
done
