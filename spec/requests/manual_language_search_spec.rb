require 'rails_helper'

RSpec.describe "Manual language search", :type => :request do

  before(:all) do
    @data_set = load_data_set
  end

  before(:each) do
    allow_any_instance_of(DataSet).to receive(:data_set).and_return(@data_set)
  end

  it "displays the search result in a table" do
    get '/manual_languages', {search: 'Interpreted "Thomas Eugene"'}
    assert_select "table#search-results-table" do
      assert_select "tr:nth-child(1)" do
        assert_select 'td:nth-child(1)', 'BASIC'
        assert_select 'td:nth-child(2)', /Interpreted/
        assert_select 'td:nth-child(3)', /Thomas Eugene/
      end
    end
  end
end