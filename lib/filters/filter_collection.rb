module Filters
  class FilterCollection

    # Ruby doesn't have Interfaces like other languages,
    # if it would, this classes would implement the same interface
    FILTERS = [
      'Filters::ExcludeFilter',
      'Filters::PhraseFilter',
      'Filters::WordFilter'
    ]

    def initialize(search_string)
      @filters = FILTERS.map {|filter| filter.constantize.new(search_string.downcase) }
    end

    # It applies each applicable filter to the data item
    # If the filter is exclusive, the data item is not included in the results
    # It also calculates the total relevance of the data item in the result set depending on the filters' relevance
    # @param [Hash] :field => value style hash
    # @return [boolean] if the data item match the search criteria
    def apply(searchable)
      @relevance = 0
      @filters.each do |filter|
        if filter.valid?
          if filter.match(searchable)
            @relevance += filter.relevance
          else
            return false if filter.exclusive?
          end
        end
      end
      @relevance > 0
    end

    def relevance
      @relevance
    end

  end
end