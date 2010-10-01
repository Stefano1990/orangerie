# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Example User"
  user.email                 "foobar@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
  user.trusted               true
end

Factory.sequence :email do |n|
  "person-#{n}@foobar.com"
end

Factory.sequence :name do |n|
  "Foo bar -#{n}"
end