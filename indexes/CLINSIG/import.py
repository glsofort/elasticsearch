import argparse
from elasticsearch import Elasticsearch
from elasticsearch.helpers import bulk

user_login="elastic"
index_name="clinsig"

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
                'order_id': fields[0],
                'key': fields[1],
                'chrom': fields[2],
                'pos': fields[3],
                'ref': fields[4],
                'alt': fields[5],
                'variant_id': fields[6],
                'clinsig': fields[7],
                'clinsig_ch': fields[8]
            }
            action = {
                '_index': index_name,
                '_source': doc
            }
            actions.append(action)
            i+=1
    # Perform the bulk indexing
    print('Importing CLINSIG')
    bulk(es, actions)
    print('Finish CLINSIG')

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