namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    
    admin = User.create!(first_name: "User",
                        last_name: "Administrator",
                        nickname: "admin",
                        email: "admin@railstutorial.org",
                        password: "qazxsw",
                        password_confirmation: "qazxsw")
    admin.toggle!(:admin)

    User.create!(first_name: "User",
     last_name: "Example", 
     email: "Example@railstutorial.org",
     nickname: "example_nick",
     password: "foobar",
     password_confirmation: "foobar")
    99.times do |n|
      first_name  = Faker::Name.first_name
      last_name = Faker::Name.last_name
      email = "example-#{n+1}@railstutorial.org"
      nickname = "example_nick-#{n+1}"
      password  = "password"
      User.create!(first_name: first_name,
                   last_name: last_name,
                   email: email,
                   nickname: nickname,
                   password: password,
                   password_confirmation: password)
    end

    users = User.all(limit: 5)
    
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content)}
    end

  end
end