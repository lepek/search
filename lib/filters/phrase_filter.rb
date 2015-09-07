##
# This class handles the exact matches
# It is capable to handle more than one exact match criteria
# If a exact matches is searched, it will be mandatory for any result to match at least one of them
# Depending in which field the exact match is found, the relevance of the result changes
#
module Filters
  class PhraseFilter

    # Any phrase enclosed between `"`
    EXACT_MATCHES_REGEX = /"([^()]*?)"/

    # This filter has a great relevance,
    # making the results passing the filter relevant in the final result set
    BASE_RELEVANCE = 10

    # For this filter, a relevance by field is implemented
    FIELD_RELEVANCE = { 'Name' => 3, 'Type' => 2, 'Designed by' => 1 }

    # if this filter fails,
    # there is no need to keep applying filters to the data item
    # and we can ignore it
    EXCLUSIVE = true

    # it supports more than one exact match in the search criteria
    # by scanning for all the instances of the exact match pattern
    def initialize(search_string)
      @search_string = search_string
      @phrase_parts = @search_string.scan(EXACT_MATCHES_REGEX).flatten!
      @phrase_parts.map! { |part| part.strip.squeeze(' ') } if @phrase_parts.present?
    end

    def valid?
      @phrase_parts.present?
    end

    def match?(searchable)
      @phrase_parts.present? && match_searchable_part?(searchable)
    end

    def exclusive?
      EXCLUSIVE
    end

    # it calculates the relevance of the data item depending on
    # how many and which fields matched
    def relevance
      BASE_RELEVANCE * @relevance.compact.inject(:*) if @relevance
    end

    private

    def add_relevance(field)
      @relevance ||= []
      @relevance << FIELD_RELEVANCE[field] unless FIELD_RELEVANCE[field].nil?
    end

    def match_searchable_part?(searchable)
      @relevance = []
      @phrase_parts.each do |part|
        searchable.each do |key, value|
          add_relevance(key) if value.downcase.include?(part)
        end
      end
      @relevance.present?
    end

  end
end