### Table will be moved to elasticsearch to have a better performance:

1. phenotypes x
2. HGNC x
3. HGMD x
4. genes x
5. gene_phenotype x
6. CLINSIG x
7. clinvar_max_af x
8. transcript_info x

### Build script test progress

1. gene_clinical_synopsis x
2. phenotype_term x
3. gene_phenotype x
4. hgnc x
5. genes x
6. hgmd x
7. clinsig x
8. clinvar_max_af
9. transcript_info

### Index progress

1. gene_clinical_synopsis x
2. phenotype_term x
3. gene_phenotype x
4. hgnc x
5. genes
6. hgmd x
7. clinsig x
8. clinvar_max_af x
9. transcript_info x

## Indexes

### gene_clinical_synopsis

Number of versions (2):

- Chinese
- English

Notes:

- Based on OMIM database.
- Based on table `gene_clinical_synopsis` and `phenotypes`(omim) (From OMIM).
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
  "pheno_description": "phenotypes.description",
  "location": "gene_clinical_synopsis.location"
}
```

Data retrieval:

```sql
SELECT
	g.gene_name as gene_name,
	g.gene_omim as gene_mim_number,
	CASE WHEN g.pheno_omim = '' or g.pheno_omim is null THEN '.' ELSE g.pheno_omim END AS pheno_mim_number,
	IF (p.name is not null and p.name != "", p.name, g.pheno_name ) as pheno_name,
	p.clinical_synopsis as clinical_synopsis,
	p.description as pheno_description,
  g.location as location
FROM
	gene_clinical_synopsis AS g
	LEFT JOIN omim AS p ON g.pheno_omim = p.omim_number
```

### phenotype_term

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

### gene_phenotype

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

```sql
SELECT
	CASE WHEN Disease_ID = '' THEN '.' ELSE Disease_ID END AS disease_id,
	Source AS source,
	CASE WHEN gene_symbol = '' THEN '.' ELSE gene_symbol END AS gene_name,
	gene_id,
	HPO_ID AS HPO_id,
	HPO_text AS english_term,
	HPO_term_name AS term
FROM
	gene_phenotype;

SELECT * FROM gene_phenotype WHERE length(HPO_term_name) = char_length(HPO_term_name);

UPDATE gene_phenotype SET HPO_text = HPO_term_name WHERE HPO_text is null
```

### hgnc

Number of versions (1):

- English

Notes:

- Based on `HGNC` table.

```sql
SELECT gene_name, hgnc_id as HGNC_id FROM HGNC
```

```json
{
  "gene_name": "HGNC.gene_symbol",
  "HGNC_id": "HGNC.hgnc_id"
}
```

### genes

Number of versions (1):

Notes:

- Based on `genes` table.

```sql
UPDATE genes
SET `function` =
IF
	(
		NCBI_summary IS NOT NULL
		AND NCBI_summary != "",
		NCBI_summary,
	IF
		(
			summary IS NOT NULL
			AND summary != "",
			summary,
	IF
	( GHR_summary IS NOT NULL AND GHR_summary != "", GHR_summary, NULL )));

UPDATE genes
INNER JOIN genes_zh ON genes.id = genes_zh.id
SET genes.`function_ch` = IF (genes_zh.`function` is not null and genes_zh.`function` != "", genes_zh.`function`, NULL)
WHERE genes.`function_ch` is null and  genes.`function` is not null;

UPDATE genes
 SET GHR_metadata=REPLACE(GHR_metadata,'\n',' '),
 GHR_metadata_ch=REPLACE(GHR_metadata_ch,'\n',' '),
 function_ch=REPLACE(function_ch, '\n', ' '),
 `function`=REPLACE(`function`, '\n', ' ');

UPDATE genes
 SET GHR_metadata=REPLACE(GHR_metadata,'\r',' '),
 GHR_metadata_ch=REPLACE(GHR_metadata_ch,'\r',' '),
 function_ch=REPLACE(function_ch, '\r', ' '),
 `function`=REPLACE(`function`, '\r', ' ');

SELECT NAME AS
	gene_name,
	CASE WHEN full_name is null or full_name = "" THEN '.' ELSE full_name END AS full_name,
	CASE WHEN `function` is null or `function` = "" THEN '.' ELSE `function` END AS `function`,
	CASE WHEN GHR_metadata is null or GHR_metadata = "" THEN '.' ELSE GHR_metadata END AS GHR_metadata,
	CASE WHEN function_ch is null or function_ch = "" THEN '.' ELSE function_ch END AS function_ch,
	CASE WHEN GHR_metadata_ch is null or GHR_metadata_ch = "" THEN '.' ELSE GHR_metadata_ch END AS GHR_metadata_ch
FROM
	`genes`
```

```json
{
  "gene_name": "genes.name",
  "full_name": "genes.full_name",
  "function": "genes.function",
  "GHR_metadata": "genes.GHR_metadata",
  "function_ch": "genes.function_ch",
  "GHR_metadata_ch": "genes.GHR_metadata_ch"
}
```

### hgmd

Number of versions (1):

- English

Notes:

- Based on `HGMD` table

```sql
SELECT
	CONCAT( CHROM, "_", POS, "_", REF, "_", ALT ) AS `key`,
	CHROM AS chrom,
	POS AS pos,
	REF AS ref,
	ALT AS alt,
	INFO AS info
FROM
	HGMD
```

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

```sql
SELECT
	CONCAT( CHROM, "_", POS, "_", REF, "_", ALT ) AS `key`,
	CHROM AS chrom,
	POS AS pos,
	REF AS ref,
	ALT AS alt,
	VARIANT_ID AS variant_id,
	CASE WHEN CLNSIG is null THEN '.' ELSE CLNSIG END AS clinsig,
	CASE WHEN CLNSIG_CH is null THEN '.' ELSE CLNSIG_CH END AS clinsig_ch
FROM
	`CLINSIG`
```

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

```sql
SELECT gene as gene_name, MAX_AF as max_af, MAX_AF_POPS as max_af_pop FROM clinvar_max_af
```

```json
{
  "gene_name": "clinvar_max_af.gene",
  "max_af": "clinvar_max_af.MAX_AF",
  "max_af_pop": "clinvar_max_af.MAX_AF_POPS"
}
```

### transcript_info

Number of versions (1):

- English

Notes:

- Based on table `transcript_info`.

```sql
SELECT ENSG, ENST, gene as gene_name, length, CASE WHEN transcript is not null THEN transcript else "." END as transcript FROM transcript_info
```

```json
{
  "ENSG": "transcript_info.ENSG",
  "ENST": "transcript_info.ENST",
  "gene_name": "transcript_info.gene",
  "length": "transcript_info.length",
  "transcript": "transcript_info.transcript"
}
```
