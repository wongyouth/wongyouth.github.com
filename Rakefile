# Rakefile
namespace :deploy do
  def deploy(env)
    puts "Deploying to #{env}"
    system "TARGET=#{env} bundle exec middleman deploy"
  end

  task :gitcafe do
    deploy :gitcafe
  end

  task :github do
    deploy :github
  end
end

task :deploy => 'deploy:gitcafe'
task :default => :deploy

