#!/bin/bash

while getopts p: flag; do
    case "${flag}" in
    p) ELASTIC_PASSWORD=${OPTARG};;
    esac
done

if [ -z "${ELASTIC_PASSWORD}" ]; then
    echo "Elastic Password is required. Please specify -p option!"
    exit -1
fi

ROOT_FOLDER=${PWD}

# CLINSIG
cd ${ROOT_FOLDER}/indexes/CLINSIG
unzip data.zip
/bin/bash build.sh

# clinvar_max_af
cd ${ROOT_FOLDER}/indexes/clinvar_max_af
/bin/bash build.sh

# gene_clinical_synopsis

# gene_phenotype
