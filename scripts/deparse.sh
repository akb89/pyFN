#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/setup.sh"

show_help() {
cat << EOF
Usage: ${0##*/} [-h] -f FILE -p {mst,bmst,barch}
Dependency-parse a given .conllx file with a specified parser.

  -h, --help                     display this help and exit
  -f, --file   FILE              absolute path to input .conllx file
  -p, --parser {mst,bmst,barch}  dependency parser to be used: 'mst', 'bmst' or 'barch'
EOF
}

is_input_file_set=FALSE
is_parser_set=FALSE

while :; do
    case $1 in
        -h|-\?|--help)
            show_help
            exit
            ;;
        -f|--file)
            if [ "$2" ]; then
                is_input_file_set=TRUE
                file=$2
                shift
            else
                die "ERROR: '--file' requires a non-empty option argument"
            fi
            ;;
        -p|--parser)
            if [ "$2" ]; then
                is_parser_set=TRUE
                parser=$2
                shift
            else
                die "ERROR: '--parser' requires a non-empty option argument"
            fi
            ;;
        --)
            shift
            break
            ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *)
            break
    esac
    shift
done

if [ "${is_input_file_set}" = FALSE ]; then
    die "ERROR: '--file' parameter is required."
fi

if [ "${is_parser_set}" = FALSE ]; then
    die "ERROR: '--parser' parameter is required."
fi

case "${parser}" in
    mst )
        ;;   #fallthru
    bmst )
        ;;   #fallthru
    barch )
        ;;   #fallthru
    * )
        die "Invalid dependency parser '${parser}': Should be 'mst', 'bmst' or 'barch'"
esac

convert_mst_to_conllx() {
  local MST_FILE=$1
  local CONLLX_FILE=$2
  local OUTPUT_TMP_DIR="/tmp/mst"

  rm -rf $OUTPUT_TMP_DIR 2> /dev/null
  mkdir ${OUTPUT_TMP_DIR} 2> /dev/null

  cut -f 1-6 ${CONLLX_FILE} > ${OUTPUT_TMP_DIR}/conllx.first.to.sixth
  cut -f 7-8 ${MST_FILE} > ${OUTPUT_TMP_DIR}/mst.seventh.to.eigth
  cut -f 9-10 ${CONLLX_FILE} > ${OUTPUT_TMP_DIR}/ninth.to.tenth

  paste ${OUTPUT_TMP_DIR}/conllx.first.to.sixth ${OUTPUT_TMP_DIR}/mst.seventh.to.eigth ${OUTPUT_TMP_DIR}/ninth.to.tenth | perl -pe "s/^\t+$//g" > ${CONLLX_FILE}.tmp

  rm ${MST_FILE}
  rm -rf $OUTPUT_TMP_DIR
}

echo "Initializing dependency parsing..."

mkdir ${LOGS_DIR} 2> /dev/null

if [ "${parser}" = "mst" ]; then
    # echo "Preparing .conllx input for MST parsing..."
    # echo "Processing file: ${file}"
    # #prepare_mst_input $file
    # python3 ${SCRIPTS_DIR}/CoNLLizer.py conll -f 1-10 -r 7 -w 0 ${file} ${file} > ${file}.mst
    # echo "Done"
    # echo "Dependency-parsing via MSTParser..."
    # echo "Processing file: ${file}"
    # pushd ${MST_PARSER_HOME}
    # ${JAVA_HOME_BIN}/java \
    #   -classpath ".:./lib/trove.jar:./lib/mallet-deps.jar:./lib/mallet.jar" \
    # 	-Xms${min_ram} \
    # 	-Xmx${max_ram} \
    # 	mst.DependencyParser \
    # 	test \
    # 	separate-lab \
    # 	model-name:${mst_parser_model} \
    # 	decode-type:proj \
    # 	order:2 \
    # 	test-file:${file} \
    # 	output-file:${file}.mst \
    # 	format:CONLL > ${LOGS_DIR}/mst.log
    # echo "Done"
    # echo "Converting .mst to .conllx..."
    # echo "Processing file: ${file}.mst"
    #convert_mst_to_conllx ${file}.mst ${file}
    python3 ${SCRIPTS_DIR}/CoNLLizer.py conll -f 1-6,9-10 ${file} -f 7-8 ${file}.mst
    echo "Done"
fi

if [ "${parser}" = "bmst" ]; then
  echo "Dependency-parsing via BIST MST parser..."
  echo "Processing file: ${file}"
  OUTPUT_DIR=$(dirname "${file}")
  python ${BMST_PARSER_HOME}/parser.py \
      --predict \
      --outdir ${OUTPUT_DIR} \
      --test ${file} \
      --extrn ${bist_external_vectors} \
      --model ${bmst_model} \
      --params ${bmst_params} 2> ${LOGS_DIR}/bmst.log
  rm "${OUTPUT_DIR}/test_pred.conll.txt"
  mv "${OUTPUT_DIR}/test_pred.conll" "${file}"
  echo "Done"
fi

if [ "${parser}" = "barch" ]; then
  echo "Dependency-parsing via BIST ARCH parser..."
  echo "Processing file: ${file}"
  OUTPUT_DIR=$(dirname "${file}")
  python ${BARCH_PARSER_HOME}/parser.py \
      --predict \
      --outdir ${OUTPUT_DIR} \
      --test ${file} \
      --extrn ${bist_external_vectors} \
      --model ${barch_model} \
      --params ${barch_params} 2> ${LOGS_DIR}/barch.log
  rm "${OUTPUT_DIR}/test_pred.conll.txt"
  mv "${OUTPUT_DIR}/test_pred.conll" "${file}"
  echo "Done"
fi
