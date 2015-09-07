require "rails_helper"

RSpec.describe ManualLanguagesController, :type => :controller do

  before(:all) do
    @data_set = load_data_set
  end

  ##
  # We want to have control over the test data set in case the production one changes,
  # so we use our own data set, even if it's the same for this particular test app
  #
  before(:each) do
    allow_any_instance_of(DataSet).to receive(:data_set).and_return(@data_set)
  end

  describe "GET #index" do

    it "loads search results into @results" do
      get :index, {search: 'Interpreted "Thomas Eugene"'}
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(assigns(:results).first.keys).to match(['Name', 'Type', 'Designed by'])
      expect(assigns(:results).first['Name']).to match('BASIC')
      expect(assigns(:results).count).to eq(1)
    end

  end
end