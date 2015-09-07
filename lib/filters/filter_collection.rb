module Filters
  class FilterCollection

    ##
    # Ruby doesn't have Interfaces like other languages,
    # if it would, this classes would implement the same interface.
    # Also, they could inherit from a parent class. Ruby doesn't have
    # abstract classes neither.
    # We can simulate both things with some work if we really need them,
    # in this case I will keep it like this since there aren't too many methods
    # I could move to a parent class and because of the time constraints.
    # An interface would be interesting here though, to be sure the filters
    # implements the very same set of methods for the FilterCollection.
    # This is an approach that I have followed in the past
    # (it has to be modified a little bit since it is and old post):
    # http://metabates.com/2011/02/07/building-interfaces-and-abstract-classes-in-ruby/
    # If this would be a bigger app, or a team would work on it, I think it may be worth
    # to take a look to a similar approach.
    #
    FILTERS = [
      'Filters::ExcludeFilter',
      'Filters::PhraseFilter',
      'Filters::WordFilter'
    ]

    def initialize(search_string)
      @filters = FILTERS.map { |filter| filter.constantize.new(search_string.downcase) }
      @applicable_filters = @filters.select { |filter| filter.valid? }
      @cache = {}
    end

    # Returns the relevance from the cache if it exists or calculates it if it's not
    # @param [Hash] :field => value style hash
    # @return [Integer] the relevance of the result
    def apply!(searchable)
      return relevance_from_cache(searchable) if relevance_from_cache(searchable).present?
      apply_filters(searchable)
    end

    # @return [Boolean] if the result is valid for the current filters
    def valid?(searchable)
      apply!(searchable) > 0
    end

    private

    # It applies each applicable filter to the data item
    # and calculates the total relevance of the data item depending on
    # the matching filters' relevance and it saves it in the cache
    def apply_filters(searchable)
      relevance = 0
      @applicable_filters.each do |filter|
        if filter.match(searchable)
          relevance += filter.relevance
        else
          relevance = 0 and break if filter.exclusive?
        end
      end
      relevance_cache(searchable, relevance)
      relevance
    end

    # This could be store in Redis in a production app
    # Also, the way in which is indexed can be improved in a real app
    def relevance_cache(searchable, relevance)
      @cache.merge!({ Digest::MD5.hexdigest(searchable.to_s) => relevance })
    end

    def relevance_from_cache(searchable)
      @cache[Digest::MD5.hexdigest(searchable.to_s)]
    end
  end
end