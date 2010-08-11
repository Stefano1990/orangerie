require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
  end
end
def make_users
  User.create!(:name => "Example User", 
               :email => "example@foobar.com",
               :password => "foobar", 
               :password_confirmation => "foobar")

  99.times do |n|
    name = "Example User -#{n+1}"
    email = "example-#{n+1}@foobar.com"
    password = "password"
    User.create!(:name => name, 
                 :email => email, 
                 :password => password,
                 :password_confirmation => password)
  end
end