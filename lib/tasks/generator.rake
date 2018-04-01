require 'csv'
file_root = "/data/seeds"
namespace :generator do
  desc 'generate students'
  task :students => :environment do
    begin
      STDOUT.puts "Input seed file name : "
      input = STDIN.gets.strip.downcase
    end until input.present?

    seed_path = File.join(file_root, input)
    CSV.foreach(seed_path) do |row|
      name = row[0]
      password = row[1]
      Student.create(name: name, password: password)
    end
  end

  desc 'generate admins'
  task :admins => :environment do
    begin
      STDOUT.puts "Input seed file name : "
      input = STDIN.gets.strip.downcase
    end until input.present?

    seed_path = File.join(file_root, input)
    CSV.foreach(seed_path) do |row|
      name = row[0]
      password = row[1]
      Admin.create(name: name, password: password)
    end
  end

  desc 'generate interactive'
  task :interactive => :environment do
    begin
      STDOUT.puts "student/admin? (s/a)"
      type = STDIN.gets.strip.downcase
    end until type.present?

    begin
      STDOUT.puts "Input name : "
      name = STDIN.gets.strip.downcase
    end until name.present?

    begin
      STDOUT.puts "Input password : "
      password = STDIN.gets.strip.downcase
    end until password.present?

    if type == 's'
      Student.create(name: name, password: password)
    elsif type == 'a'
      Admin.create(name: name, password: password)
    end
  end
end