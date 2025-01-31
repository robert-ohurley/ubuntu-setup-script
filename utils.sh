
setHomePath() {
	echo "Enter path to users home directory e.g. /home/rojet: "
	read path
	export HOME=path
}

makeDirIfNotExist() {
	if [ ! -d $1 ]; then
		mkdir $1
	fi
}

continue?() {
	echo "Do you want to continue? (y/n)"
	read answer
	if [ $answer == "n" ]; then
		exit
	fi
}
