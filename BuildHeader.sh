PREFIX=`echo ${PROJECT_NAME} | awk '{print toupper($0)}'`

BUILD_FILENAME="${PROJECT_NAME}Build.h"
BUILD_HEADER="${BUILT_PRODUCTS_DIR}/$BUILD_FILENAME"

GIT_REV_SHA=$(git --git-dir="${PROJECT_DIR}/.git" --work-tree="${PROJECT_DIR}" rev-parse --short HEAD)
GIT_BRANCH=$(git --git-dir="${PROJECT_DIR}/.git" --work-tree="${PROJECT_DIR}" symbolic-ref --short -q HEAD)

rm -f ${BUILD_HEADER} &> /dev/null

echo "// $BUILD_FILENAME" > $BUILD_HEADER
echo "#define ${PREFIX}_BUILD_SHA @\"$GIT_REV_SHA\"" >> $BUILD_HEADER
echo "#define ${PREFIX}_BUILD_BRANCH @\"$GIT_BRANCH\"" >> $BUILD_HEADER
echo "#define ${PREFIX}_BUILD_DATE @\"`date`\"" >> $BUILD_HEADER
echo "#define ${PREFIX}_BUILD_DATE_SHORT @\"`date +\"%x %X\"`\"" >> $BUILD_HEADER
echo "#define ${PREFIX}_BUILD_USER @\"`git config user.name`\"" >> $BUILD_HEADER
