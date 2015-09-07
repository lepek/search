##
# This class handles the negative searches
# It works in conjunction to other search criteria, to filter them out
#
module Filters
  class ExcludeFilter

    # Any word starting with `-`
    EXCLUDE_PARTS_REGEX = /-([^()]\w+)/

    # All the words between commas and blank spaces
    SPLIT_REGEX = /,*\s+,*/

    # The relevance for this filter is not relevant
    BASE_RELEVANCE = 0

    # This filter is exclusive.
    # If it fails, it will make the data item to be ignored from the final results
    EXCLUSIVE = true

    def initialize(search_string)
      @search_string = search_string
      @exclude_parts = @search_string.scan(EXCLUDE_PARTS_REGEX).flatten!
    end

    # It decides if the method is applicable or not
    def valid?
      @exclude_parts.present?
    end

    # It uses an array operation, an intersection,
    # to know if any of the not wanted keywords are present in the data item
    def match?(searchable)
      @exclude_parts.present? ? (tokenize(searchable) & @exclude_parts).blank? : true
    end

    def exclusive?
      EXCLUSIVE
    end

    def relevance
      BASE_RELEVANCE
    end

    private

    # It converts the data item in an array of keywords
    # This method can be highly improve doing things like
    # removing non relevant keywords like `and`, `or`, etc
    # or taking in account other splits criteria
    def tokenize(data)
      data.map { |_, value| value.downcase.split(SPLIT_REGEX) }.flatten
    end

  end
end
