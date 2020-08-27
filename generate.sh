CURRENT_DIR=`pwd`
PROJECT_PATTERN="effect"
PROJECT_NAME="AcidsAudioPlugin"
TARGET_NAME=""
OUTPUT=$CURRENT_DIR
CMAKE_BACKEND='Unix Makefiles'

usage() { 
    echo "usage : $0 -n NAME [-m PROJECT_NAME] [-o OUTPUT] [-b BACKEND] [-p PATTERN]" 1>&2 
}

exit_abnormal() { 
    usage
    exit 1
}

while getopts ":n:o:p:m:g:" options; do
    case "${options}" in
        n) 
            TARGET_NAME=${OPTARG}
            ;;
        o) 
            OUTPUT=${OPTARG}
            ;;
        g)
            CMAKE_BACKEND=${OPTARG}
            ;;
        p)
            PROJECT_PATTERN=${OPTARG}
            ;;
        m)
            PROJECT_NAME=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

echo "target name : " $TARGET_NAME 
echo "project name : " $PROJECT_NAME
echo "project pattern : "$PROJECT_PATTERN
echo "output directory : " $OUTPUT 
echo "backend : " $CMAKE_BACKEND


if [ -z ${TARGET_NAME} ]
then
    exit_abnormal
fi

if [ ! -d $OUTPUT ]
then
    mkdir $OUTPUT
else
    if [ ! -z "$(ls -A $OUTPUT)" ]; then
        echo 
        while true; do
            read -p "Directory $OUTPUT is not empty. Proceed? [y/n] : " yn
            case $yn in
                [Yy]* ) break;;
                [Nn]* ) exit;;
                * ) echo "Please answer yes or no.";;
            esac
        done
    fi
fi
        
if [ ! -d patterns/${PROJECT_PATTERN} ]
then
	echo "[ERROR] Pattern ${PROJECT_PATTERN} not found"
fi

cd ${OUTPUT}
OUTPUT_DIR=`pwd`
# copy files from template and process substitutions
while IFS="" read -r p || [ -n "$p" ]
do
  sed 's/${PLUGIN_CLASS_NAME}'/${TARGET_NAME}/g $CURRENT_DIR/patterns/${PROJECT_PATTERN}/$p > $p
done < $CURRENT_DIR/patterns/${PROJECT_PATTERN}/FileList.txt

# copy CMakeLists file
cp $CURRENT_DIR/patterns/${PROJECT_PATTERN}/CMakeLists.txt .
sed -i dull 's/${PLUGIN_CLASS_NAME}'/${TARGET_NAME}/g CMakeLists.txt 
sed -i dull 's/${PLUGIN_PROJECT_NAME}'/${PROJECT_NAME}/g CMakeLists.txt 
rm CMakeLists.txtdull

# check libtorch
if [ ! -d "libtorch/" ]
then
    echo "libtorch not found ; downloading..."
    TORCH_VERSION=`python -c "import torch; print(torch.__version__)"`
    echo "-- detected torch version : ${TORCH_VERSION}"
    wget "https://download.pytorch.org/libtorch/cpu/libtorch-macos-${TORCH_VERSION}.zip"
    unzip "libtorch-macos-${TORCH_VERSION}.zip"
    rm "libtorch-macos-${TORCH_VERSION}.zip"
fi

# check juce 
if [ ! -d "JUCE" ]
then
    git clone https://github.com/juce-framework/JUCE.git
fi


echo "Generating..."
if [ -d build ]
then
	rm -rf build
fi
mkdir build
cd build

CMAKE_PREFIX_PATH=${OUTPUT_DIR}/libtorch
echo ${CMAKE_PREFIX_PATH}
cmake -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -G "${CMAKE_BACKEND}" -DJUCE_BUILD_EXAMPLES=OFF -DJUCE_BUILD_EXTRAS=OFF .. 
