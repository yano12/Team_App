Team.create!(name:  "Example Team",
             password:              "basket",
             password_confirmation: "basket")

99.times do |n|
  name  = Faker::Name.name
  password = "password"
  Team.create!(name:  name,
               password:              password,
               password_confirmation: password)
end

team = Team.first
30.times do |n|
  player  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  team.players.create!(name:  player, 
                       email: email,
                       password:              password,
                       password_confirmation: password)
end