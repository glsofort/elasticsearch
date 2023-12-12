#!/bin/bash

while getopts p: flag; do
    case "${flag}" in
    p) elastic_password=${OPTARG};;
    esac
done

if [ -z "${elastic_password}" ]; then
    echo "Elastic Password is required. Please specify -p option!"
    exit -1
fi

export ELASTIC_PASSWORD=${elastic_password}

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
