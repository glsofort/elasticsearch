import argparse
from elasticsearch import Elasticsearch
from elasticsearch.helpers import bulk

def main(index_name, file_path):
    # Connect to Elasticsearch
    es = Elasticsearch([{'host': 'localhost', 'port': 9200, "scheme": "http"}])

    # Define the index name and other settings
    doc_type = '_doc'

    # Read the TSV file and prepare bulk indexing requests
    actions = []
    i = 0
    with open(file_path, 'r') as file:
        for line in file:
            fields = line.strip().split('\t')
            print(i)
            doc = {
                'omim_id': fields[0],
                'source': fields[1],
                'gene_name': fields[2],
                'gene_id': fields[3],
                'hpo_id': fields[4],
                'english_term': fields[5],
                'term': fields[6]
            }
            action = {
                '_index': index_name,
                '_source': doc
            }
            actions.append(action)
            i+=1
    # Perform the bulk indexing
    bulk(es, actions)

if __name__ == '__main__':
    # Create the argument parser
    parser = argparse.ArgumentParser(description='Import TSV to Elastic Search')

    # Add arguments
    parser.add_argument('--index', type=str, help='Index Name')
    parser.add_argument('--file', type=str, help='File path')

    # Parse the command-line arguments
    args = parser.parse_args()

    # Access the argument values
    arg1_value = args.index
    arg2_value = args.file

    # Call the main function with the argument values
    main(arg1_value, arg2_value)