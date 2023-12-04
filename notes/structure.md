### Table will be moved to elasticsearch to have a better performance:

1. phenotypes x
2. HGNC x
3. HGMD x
4. genes x
5. gene_phenotype x
6. CLINSIG x
7. clinvar_max_af x
8. transcript_info x


### More information

#### Filter variants


#### Create sample

### gene_clinical_synopsis

Number of versions (2):
- Chinese
- English

Notes:
- Based on OMIM database.
- Based on table `gene_clinical_synopsis` and `phenotypes` (From OMIM).
- Indicates relationship between genes and clinical synopsis + phenotype names in OMIM database

Purpose: 
1. Find `clinical_synopsis` from `gene_name`
2. Find `gene_name` from terms (exist in `pheno_name` and `clinical_synopsis` field)

Format:
```json
{
    "gene_name": "gene_clinical_synopsis.gene_name",
    "gene_mim_number": "gene_clinical_synopsis.gene_omim",
    "pheno_mim_number": "gene_clinical_synopsis.pheno_omim",
    "pheno_name": "phenotypes.name", //  Chinese | English (with phenotypes.omim_number = gene_clinical_synopsis.pheno_omim)
    "clinical_synopsis": "phenotypes.clinical_synopsis", //  Chinese | English (with phenotypes.omim_number = gene_clinical_synopsis.pheno_omim)
    "pheno_description": "phenotypes.description"
}
```

Data retrieval:
```sql
SELECT
	g.gene_name as gene_name,
	g.gene_omim as gene_mim_number,
	g.pheno_omim as pheno_mim_number,
	p.name as pheno_name,
	p.clinical_synopsis as clinical_synopsis,
	p.description as pheno_description
FROM
	gene_clinical_synopsis AS g
	LEFT JOIN phenotypes AS p ON g.pheno_omim = p.omim_number
```

### phenotype_term x

Number of versions: 1 (only english term only)

Notes:
- Based on HPO database in table `gene_phenotype`.
- This index only contain terms in English.
- Optimized with fuzzy English input.
- Indicates list of English terms.

Purpose:
1. Find `term` based on fuzzy input phenotype.

```json
{
    "term": "gene_phenotype.HPO_search"
}
```


### gene_phenotype x

Number of versions: 1 (using smartcn analyzer for term data contains both chinese & english)

Notes:
- Based on HPO database in table `gene_phenotype`.
- Indicates relationship between genes and phenotypes in HPO database.

Purpose:
1. Find `gene_name` from `term`.
2. Find `term` based on fuzzy input phenotype.

```json
{
    "gene_name": "gene_phenotype.gene_symbol",
    "term": "gene_phenotype.HPO_term_name", //  Can be chinese or english
    "english_term": "gene_phenotype.HPO_text",
    "disease_id": "gene_phenotype.Disease_ID",
    "HPO_id": "gene_phenotype.HPO_ID",
    "source": "gene_phenotype.Source",
    "gene_id": "gene_phenotype.gene_id"
}
```

### hgnc

Number of versions (1):
- English

Notes:
- Based on `HGNC` table.

```json
{
    "gene_name": "HGNC.gene_symbol",
    "hgnc_id": "HGNC.hgnc_id"
}
```

### genes

Number of versions (2):
- English
- Chinese

Notes:
- Based on `genes` table.

```json
{
    "gene_name": "genes.name",
    "full_name": "genes.full_name",
    "function": "genes.function", //  Chinese | English 
    "GHR_metadata": "genes.GHR_metadata" // Chinese | English
}
```

### hgmd

Number of versions (1):
- English

Notes:
- Based on `HGMD` table

```json
{
    "key": "HGMD.chrom_HGMD.pos_HGMD.ref_HGMD.alt",
    "chrom": "HGMD.chrom",
    "pos": "HGMD.pos",
    "ref": "HGMD.ref",
    "alt": "HGMD.alt",
    "info": "HGMD.info"
}
```

### clinsig

Number of versions (1):
- English

Notes:
- Based on `CLINSIG` table.

```json
{
    "key": "CLINSIG.chrom_CLINSIG.pos_CLINSIG.ref_CLINSIG.alt",
    "chrom": "CLINSIG.chrom",
    "pos": "CLINSIG.pos",
    "ref": "CLINSIG.ref",
    "alt": "CLINSIG.alt",
    "variant_id": "CLINSIG.variant_id",
    "clinsig": "CLINSIG.CLINSIG",
    "clinsig_ch": "CLINSIG.CLINSIG_CH"
}
```

### clinvar_max_af

Number of versions (1):
- English

Notes:
- Based on `clinvar_max_af` table.

Purpose:
- Find from `gene name`

```json
{
    "gene_name": "clinvar_max_af.gene",
    "max_af": "clinvar_max_af.MAX_AF",
    "max_af_pops": "clinvar_max_af.MAX_AF_POPS"
}
```

### transcript_info

Number of versions (1):
- English

Notes: 
- Based on table `transcript_info`.

```json
{
    "ENSG": "transcript_info.ENSG",
    "ENST": "transcript_info.ENST",
    "gene_name": "transcript_info.gene",
    "length": "transcript_info.length",
    "transcript": "transcript_info.transcript"
}
```