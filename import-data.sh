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
INDEX_PATH=${ROOT_FOLDER}/indexes

# CLINSIG
cd ${INDEX_PATH}/CLINSIG
/bin/bash build.sh

# clinvar_max_af
cd ${INDEX_PATH}/clinvar_max_af
/bin/bash build.sh

# gene_clinical_synopsis
cd ${INDEX_PATH}/gene_clinical_synopsis
/bin/bash build.sh

# gene_phenotype
cd ${INDEX_PATH}/gene_phenotype
/bin/bash build.sh

# genes
cd ${INDEX_PATH}/genes
/bin/bash build.sh

# HGMD
cd ${INDEX_PATH}/HGMD
/bin/bash build.sh

# HGNC
cd ${INDEX_PATH}/HGNC
/bin/bash build.sh

# phenotype_term
cd ${INDEX_PATH}/phenotype_term
/bin/bash build.sh

# transcript_info
cd ${INDEX_PATH}/transcript_info
/bin/bash build.sh

# gene_pli
cd ${INDEX_PATH}/gene_pli
/bin/bash build.sh

echo "Done Import"