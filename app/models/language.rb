class Language < ActiveRecord::Base

  # Enable the full text search in this fields
  searchable do
    text :name, :kind, :designed_by
  end

  ##
  # It uses the default config to search
  # It assigns some fields relevance, depending on which field the match is found.
  # This can be tune and modify in several ways.
  # To read about the default parser: https://cwiki.apache.org/confluence/display/solr/The+Standard+Query+Parser
  #
  def self.look(text)
    languages = search do
      fulltext text do
        boost_fields name: 3.0, kind: 2.0
      end
    end
    languages.results
  end

end
