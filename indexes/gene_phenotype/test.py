from elasticsearch import Elasticsearch
from elasticsearch.helpers import bulk
import argparse

def main(index_name):
    # Connect to Elasticsearch
    es = Elasticsearch([{'host': 'localhost', 'port': 9200, "scheme": "http"}])

    # Define the index name and other settings
    search_terms = ["macrocephaly", "incisor macrodontia", "macrocephaly at birth"]  # Array of search terms
    search_terms = ["macrocephaly", "incisor macrodontia"]  # Array of search terms

    # Build the Elasticsearch query
    # query = {
    #     "terms": {
    #         field_name: search_terms
    #     }
    # }

    query = {
        "bool": {
            "should": [
                {
                    "multi_match": {
                        "query": term,
                        "fields": ['clinical_synopsis', 'name']
                    }
                } for term in search_terms
            ]
        }
    }

    # query = {
    #     "match": {
    #         "clinical_synopsis": "macrocephaly"
    #     }
    # }

    source = [
        "gene_name"
    ]

    # Execute the search query
    result = es.count(index=index_name, query=query)

    search_result = es.search(index=index_name, query=query, size=10000, source=source)

    # Process the search results
    for hit in search_result['hits']['hits']:
        # Access the relevant fields from each document
        g_name = hit['_source']['gene_name']
        # Process the document as needed
        print(f"{g_name}")



    # Get the total count of documents
    total_count = result["count"]
    # print("Total Documents:", total_count)


if __name__ == '__main__':
    # Create the argument parser
    parser = argparse.ArgumentParser(description='Import TSV to Elastic Search')

    # Add arguments
    parser.add_argument('--index', type=str, help='Index Name')

    # Parse the command-line arguments
    args = parser.parse_args()

    # Access the argument values
    arg1_value = args.index

    # Call the main function with the argument values
    main(arg1_value)
