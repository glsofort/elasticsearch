#!/bin/bash

export ELASTIC_PASSWORD=$1

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