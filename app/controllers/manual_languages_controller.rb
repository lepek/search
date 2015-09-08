class ManualLanguagesController < ApplicationController

  def index
    if params[:search].present?
      languages = DataSet.instance.data_set
      filter_collection = ::Filters::FilterCollection.new(params[:search])
      @results = []

      ##
      # If the filter is produces a valid result, the result is added to the array
      # taking in account its relevance.
      # This is a O(n) algorithm. It's not the best way of doing it.
      # A better approach would be to saved an index for the data set and then just index each new entry.
      # For full-text searches, there is no rival as the inverted index data structure to boost query time performance.
      # All documents should be tokenized in simple terms and then we should build a data structure
      # where we have all documents (stored by a given id) that are matched by a term.
      # Also we could have the number of times each term matches a document,
      # useful for a more precise relevance scoring. For sake of simplicity and because we don't have new inserts here,
      # I think this algorithm accomplished the task of the test, and of course,
      # this kind of things is one of the reasons Solr or Elasticsearch are much better solutions
      #
      languages.each do |language|
        if filter_collection.valid?(language)
          relevance = filter_collection.apply!(language)
          @results[relevance] ||= []
          @results[relevance] << language
        end
      end

      # in case there are some results, it removes the nil positions,
      # flat the array and order it from the most relevant results to the less ones
      @results = @results.compact.flatten.reverse if @results.present?
    end

  end

end
