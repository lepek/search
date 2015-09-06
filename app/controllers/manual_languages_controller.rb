class ManualLanguagesController < ApplicationController

  def index
    if params[:search].present?
      languages = DataSet.instance.data_set
      filter_collection = ::Filters::FilterCollection.new(params[:search])
      @results = []

      # it applies the filters to each data item in the data set
      # if it passes, it is included in the results,
      # taking in account the relevance
      languages.each do |language|
        if filter_collection.apply(language)
          @results[filter_collection.relevance] ||= Array.new
          @results[filter_collection.relevance] << language
        end
      end

      # in case there are some results, it removes the nil positions,
      # flat the array and order it from the most relevant results to the less ones
      @results.present? ? @results.compact!.flatten!.reverse! : []
    end

  end

  private

  # In a real app the data file path should be in a config file,
  # with a per environment configuration,
  # using rconfig gem o similar to access it
  # and if it's read only it's probably a good idea to load it in an initializer.
  def read_data
    file_path = Rails.root.join('storage', 'data.json')
    JSON.parse(File.read(file_path))
  end

end
