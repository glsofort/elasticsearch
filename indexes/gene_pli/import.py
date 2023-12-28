import argparse
from elasticsearch import Elasticsearch
from elasticsearch.helpers import bulk

user_login="elastic"
index_name="gene_pli"

def main(ca_certs, file_path, password):
    # Connect to Elasticsearch
    es=Elasticsearch(hosts=["https://localhost:9200"], ca_certs=ca_certs, basic_auth=(user_login, password), verify_certs=True)

    # Define the index name and other settings
    doc_type = '_doc'

    # Read the TSV file and prepare bulk indexing requests
    actions = []
    i = 0
    with open(file_path, 'r') as file:
        for line in file:
            fields = line.strip().split('\t')
            # print(f"{i}_{fields}_{len(fields)}")
            doc = {
                "transcript": fields[0],
                "gene_name": fields[1],
                "chr": fields[2],
                "n_exons": fields[3],
                "tx_start": fields[4],
                "tx_end": fields[5],
                "bp": fields[6],
                "mu_syn": fields[7],
                "mu_mis": fields[8],
                "mu_lof": fields[9],
                "n_syn": fields[10],
                "n_mis": fields[11],
                "n_lof": fields[12],
                "exp_syn": fields[13],
                "exp_lof": fields[14],
                "exp_mis": fields[15],
                "syn_z": fields[16],
                "mis_z": fields[17],
                "lof_z": fields[18],
                "pLI": fields[19]
            }
            action = {
                '_index': index_name,
                '_source': doc
            }
            actions.append(action)
            i+=1
    # Perform the bulk indexing
    print('Importing gene_pli')
    bulk(es, actions)
    print('Finish gene_pli')

if __name__ == '__main__':
    # Create the argument parser
    parser = argparse.ArgumentParser(description='Import TSV to Elastic Search')

    # Add arguments
    parser.add_argument('--cacerts', type=str, help='Ca cert file path', required=True)
    parser.add_argument('--file', type=str, help='Data file', required=True)
    parser.add_argument('--password',  type=str, help='Password', required=True)


    # Parse the command-line arguments
    args = parser.parse_args()

    # Access the argument values
    cacerts = args.cacerts
    file = args.file
    password=args.password

    # Call the main function with the argument values
    main(file_path=file, ca_certs=cacerts, password=password)