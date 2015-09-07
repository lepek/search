module DataSetHelper

  def load_data_set
     DataSet.instance.data_set(Rails.root.join('spec', 'fixtures', 'data.json'))
  end

end