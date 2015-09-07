##
# This handle the keywords search
# Depending on how many keywords matched the relevance of the result changes
# It requires to match at least one keyword from the search criteria
#
module Filters
  class WordFilter

    # The results of this filter are not as relevant as the ones from other filters
    BASE_RELEVANCE = 2

    # It indicates that even if this filter fails,
    # it may be desirable to keep applying other filters
    EXCLUSIVE = false

    # cleaning regex
    REMOVE_EXACT_MATCHES_REGEX = /"[^()]*?"/
    REMOVE_EXCLUDE_PARTS_REGEX = /-[^()]\w+/

    SPLIT_REGEX = /,*\s+,*/

    def initialize(search_string)
      @search_string = search_string
      @words = @search_string.gsub(REMOVE_EXACT_MATCHES_REGEX, '').gsub(REMOVE_EXCLUDE_PARTS_REGEX, '').split
    end

    def valid?
      @words.present?
    end

    # The relevance is calculated depending on how much keywords match the search criteria.
    # If at least one keyword if found, the filter reports results.
    # It could be improved taking in account the matched field.
    # It could be modified to be more strict by only allowing results with all the search criteria keywords.
    def match?(searchable)
      @relevance = @words.present? ? (tokenize(searchable) & @words).count : 0
      @relevance > 0
    end

    def exclusive?
      EXCLUSIVE
    end

    def relevance
      BASE_RELEVANCE * @relevance if @relevance
    end

    private

    def tokenize(data)
      data.map { |_, value| value.downcase.split(SPLIT_REGEX) }.flatten
    end

  end
end