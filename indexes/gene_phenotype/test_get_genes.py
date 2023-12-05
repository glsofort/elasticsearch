from elasticsearch import Elasticsearch
from elasticsearch.helpers import bulk
import argparse


user_login="elastic"
index_name="gene_phenotype"
doc_size=1000000

def main(ca_certs, password):
    # Connect to Elasticsearch
    es=Elasticsearch(hosts=["https://localhost:9200"], ca_certs=ca_certs, basic_auth=(user_login, password), verify_certs=True)

    # Define the index name and other settings
    search_terms = ["abnormal", "对肋骨"]  # Array of search terms

    # Build the Elasticsearch query
    query = {
        "bool": {
            "should": [
                {
                    "match": {
                        "term": {
                            "query": term, "operator": "and"
                        }
                    }
                } for term in search_terms
            ]
        }
    }

    aggregations =  { 
        "items": { 
            "terms": {  
                "field": "term.keyword", 
                "size": doc_size 
            } 
        }
    } 
    # Execute the search query
    result = es.count(index=index_name, query=query)

    search_result = es.search(index=index_name, query=query, size=doc_size, aggregations=aggregations)

    # Process the search results
    for hit in search_result['hits']['hits']:
        # Access the relevant fields from each document
        g_name = hit['_source']['gene_name']
        # Process the document as needed
        print(f"{g_name}")

    print(len(search_result['hits']['hits']))

    # Get the total count of documents
    total_count = result["count"]
    print("Total Documents:", total_count)


if __name__ == '__main__':
    # Create the argument parser
    parser = argparse.ArgumentParser(description='Import TSV to Elastic Search')

    # Add arguments
    parser.add_argument('--cacerts', type=str, help='Ca cert file path', required=True)
    parser.add_argument('--password',  type=str, help='Password', required=True)

    # Parse the command-line arguments
    args = parser.parse_args()

    # Access the argument values
    cacerts = args.cacerts
    password=args.password

    # Call the main function with the argument values
    main(ca_certs=cacerts, password=password)
