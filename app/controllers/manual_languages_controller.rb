class ManualLanguagesController < ApplicationController

  def index
    if params[:search].present?
      languages = DataSet.instance.data_set
      filter_collection = ::Filters::FilterCollection.new(params[:search])
      @results = []

      # if the filter is produces a valid result, the result is added to the array
      # taking in account its relevance
      languages.each do |language|
        if filter_collection.valid?(language)
          relevance = filter_collection.apply!(language)
          @results[relevance] ||= []
          @results[relevance] << language
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
