class New < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name "test"

  def self.search(query="")
    __elasticsearch__.search(
      {
        "query":{
          "multi_match": {
            "query": query, 
            "fields": ["content.raw", "raw_title"]
          }
        },
        "aggs": {
          "news": {
            "terms": {
              "field": "region.keyword" 
            }
          }
        }
      }
    )
  end

  def self.search_contributors(query="")
    __elasticsearch__.search(
      {
        "query":{
          "multi_match": {
            "query": query, 
            "fields": ["content.raw", "raw_title"]
          }
        },
        "aggs": {
          "uniq_contributors":{
            "terms": {
              "field": "contributor.keyword"
            }
          },
          "publications_days": {
              "date_histogram": {
                "field": "created_at",
                "interval": "day",
                "format": "yyyy-MM-dd",
                "min_doc_count": 1
              },
              "aggs": {
                "contributors": {
                  "terms": {
                    "field": "contributor.keyword" 
                  }
                }
              }
          }
        }
      }
    )
  end

end
