# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 管理者の初期入力
# デプロイ時にコメントアウトを外す


Admin.create(:name => 'ohue', :password => 'ohue2017')
Admin.create(:name => 'keyaki', :password => 'keyaki2017')
Admin.create(:name => 'ta2017', :password => 'ta002017')

Student.create(:name => 'test.t.aa', :password => 'test2017')
# 学生アカウント作成
# 以下のようなCSV(db/students.csv)から読み込むことを想定
# name,password
#require 'csv'
#CSV.foreach('db/students.csv') do |row|
#  student_name = row[5].gsub('@m.titech.ac.jp', '')
#  password = row[4].gsub('/', '')
#  Student.create(:name => student_name, :password => password)
#end
