# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

languages = DataSet.instance.data_set

Language.delete_all

languages.each do |data|
  Language.create!(name: data['Name'], kind: data['Type'], designed_by: data['Designed by'])
end



