namespace :heroku do
  task :deploy => :environment do
    puts "Deploying application to heroku..."

    system CartoDB::Settings.inject('heroku config:add'){|command, key_value| command << " #{key_value[0]}=#{key_value[1]}"}

    system 'git push heroku master'

    puts 'Application deployed!'
  end
end
