### Table will be moved to elasticsearch to have a better performance:

1. phenotypes x
2. HGNC x
3. HGMD
4. genes
5. gene_phenotype x
6. CLINSIG
7. clinvar_max_af
8. transcript_info

### gene_clinical_synopsis

Number of versions (2):
- Chinese
- English

Note:
- Based on OMIM database
- Based on table `gene_clinical_synopsis` and `phenotypes`
- Indicates relationship between genes and clinical synopsis + phenotype names in OMIM database

Purpose: 
1. Find `clinical_synopsis` from `gene_name`
2. Find `gene_name` from terms (exist in `pheno_name` and `clinical_synopsis` field)

```json
{
    "gene_name": "gene_clinical_synopsis.gene_name",
    "gene_mim_number": "gene_clinical_synopsis.gene_omim",
    "pheno_mim_number": "gene_clinical_synopsis.pheno_omim",
    "pheno_name": "phenotypes.name", //  Chinese | English (with phenotypes.omim_number = gene_clinical_synopsis.pheno_omim)
    "clinical_synopsis": "phenotypes.clinical_synopsis" //  Chinese | English (with phenotypes.omim_number = gene_clinical_synopsis.pheno_omim)
}
```


### gene_terms

Number of versions (2):
- Chinese
- English

Note:
- Based on HPO database in table `gene_phenotype`
- Indicates relationship between genes and phenotypes in HPO database

Purpose:
1. Find `gene_name` from `term`

```json
{
    "gene_name": "gene_phenotype.gene_symbol",
    "term": "gene_phenotype.HPO_search", //  Chinese | English 
    "english_term": "gene_phenotype.HPO_text", // Only exist in chinese version
    "term_name": "gene_phenotype.HPO_term_name",
    "omim_id": "gene_phenotype.Disease_ID",
    "hpo_id": "gene_phenotype.HPO_ID",
    "source": "gene_phenotype.Source",
    "gene_id": "gene_phenotype.gene_id"
}
```

### hgnc

Number of versions (1):
- English

Note:
- Based on `HGNC` table

```json
{
    "gene_name": "HGNC.gene_symbol",
    "hgnc_id": "HGNC.hgnc_id"
}
```

Note:
- Based on `genes` table

Number of versions (2):
- English
- Chinese

```json
{
    "gene_name": "genes.name",
    "full_name": "genes.full_name",
    "function": "genes.function" //  Chinese | English 
}
```

