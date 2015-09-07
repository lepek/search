class DataSet
  include Singleton

  ##
  # In a real app the data file path should be in a config file,
  # with a per environment configuration,
  # using rconfig gem o similar to access it.
  # And probably in a real application we wouldn't load al the data set in memory.
  #
  def data_set(file_path = Rails.root.join('storage', 'data.json'))
    @data_set ||= JSON.parse(File.read(file_path))
  end

end