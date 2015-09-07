require 'rails_helper'

RSpec.describe 'FilterCollection' do

  before(:all) do
    @data_set = load_data_set
  end

  it "should return one matching when searching by a word" do
    search_string = 'actionscript'
    filter_collection = Filters::FilterCollection.new(search_string)
    results = @data_set.select { |data| filter_collection.apply!(data) > 0 }
    expect(results.count).to eq(1)
    expect(results.first['Name'].downcase).to include(search_string)
  end

  it "should return one matching when searching by a phrase" do
    search_string = '"walter bright"'
    filter_collection = Filters::FilterCollection.new(search_string)
    results = @data_set.select { |data| filter_collection.apply!(data) > 0 }
    expect(results.count).to eq(1)
    expect(results.first['Designed by'].downcase).to include(search_string.delete('"'))
  end

  it "should return one matching when searching excluding a term" do
    search_string = 'functional -interpreted'
    filter_collection = Filters::FilterCollection.new(search_string)
    results = @data_set.select { |data| filter_collection.apply!(data) > 0 }
    expect(results.count).to eq(1)
    expect(results.first['Name']).to eq('Mercury')
  end

  it 'should match "BASIC", "Haskell", "Lisp" and "S-Lang", but not "Chapel", "Fortran" or "S"' do
    matches = ["BASIC", "Haskell", "Lisp", "S-Lang"]
    no_matches = ["Chapel", "Fortran", "S"]
    search_string = 'john -array'
    filter_collection = Filters::FilterCollection.new(search_string)
    results = @data_set.select { |data| filter_collection.apply!(data) > 0 }
    expect(results.count).to eq(4)
    results.each do |result|
      expect(matches).to include(result['Name'])
      expect(no_matches).not_to include(result['Name'])
    end
  end

  it 'should match "BASIC" but not "Haskell"' do
    search_string = 'Interpreted "Thomas Eugene"'
    filter_collection = Filters::FilterCollection.new(search_string)
    results = @data_set.select { |data| filter_collection.apply!(data) > 0 }
    expect(results.count).to eq(1)
    expect(results.first['Name']).to eq('BASIC')
  end

  it 'should match microsoft scripting languages in the most relevant results' do
    search_string = 'microsoft scripting'
    matches = ['JScript', 'VBScript', 'Windows PowerShell']
    filter_collection = Filters::FilterCollection.new(search_string)
    results = []
    @data_set.each do |data|
      if filter_collection.valid?(data)
        relevance = filter_collection.apply!(data)
        results[relevance] ||= []
        results[relevance] << data
      end
    end
    results.compact!.flatten!.reverse!
    expect(results.count).to be >= matches.count
    relevant_names = results[0..matches.count - 1].map { |n| n['Name'] }
    expect((relevant_names & matches).count).to eq(matches.count)
  end

  it 'should match no matter the keywords order' do
    search_string = 'lisp common'
    matches = ['Common Lisp', 'Lisp']
    filter_collection = Filters::FilterCollection.new(search_string)
    results = []
    @data_set.each do |data|
      if filter_collection.valid?(data)
        relevance = filter_collection.apply!(data)
        results[relevance] ||= []
        results[relevance] << data
      end
    end
    results.compact!.flatten!.reverse!
    expect(results.count).to eq(2)
    relevant_names = results.map { |n| n['Name'] }
    expect(relevant_names).to eq(matches)
  end

end