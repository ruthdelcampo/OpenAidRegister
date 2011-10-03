namespace :heroku do
  task :config => :environment do
    puts "Reading config/cartodb_config.yml and sending config vars to Heroku..."

    system CartoDB::Settings.inject('heroku config:add'){|command, key_value| command << " #{key_value[0]}=#{key_value[1]}"}
  end
end
