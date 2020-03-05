echo "Bash Version: ${BASH_VERSION}"


ffmpeg_transform_second() {
	CMD="ffmpeg -i ${1} -i ${2} -c:v h264_videotoolbox -b:v 32000k ${3}"
	echo ${CMD}
    $($CMD)
}

ffmpeg_transform_first() {
	CMD="ffmpeg -c:v h264_videotoolbox -b:v 32000k -i ${1} ${2}"
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
		process_working_dir ${work_dir} "${root}/${video_director}_${P}.mp4"
    done
done