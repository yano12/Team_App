Team.create!(name:  "Example Team",
             password:              "basket",
             password_confirmation: "basket")

65.times do |n|
  name  = Faker::Name.name
  password = "password"
  Team.create!(name:  name,
               password:              password,
               password_confirmation: password)
end


team = Team.first
team.players.create!(name:  "Example Player",
                     email: "example@railstutorial.org",
                     password:              "foobar",
                     password_confirmation: "foobar",
                     admin: true,
                     team_manager: true,
                     activated: true,
                     activated_at: Time.zone.now)
                     
99.times do |n|
  player  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  team.players.create!(name:  player, 
                       email: email,
                       password:              password,
                       password_confirmation: password,
                       team_manager: false,
                       activated: true,
                       activated_at: Time.zone.now)
end

players = Player.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  players.each { |player| player.microposts.create!(content: content) }
end