namespace :oar do

  desc 'Deploy the application in staging server'
  task :deploy_staging => :environment do
    puts "Deploying application to heroku..."

    system 'git push staging master'

    puts 'Application deployed to staging environment!'
  end

  desc 'Deploy the application in production server'
  task :deploy_production => :environment do
    puts "Deploying application to heroku..."

    system 'git push heroku master'

    puts 'Application deployed to production environment!'
  end

end
