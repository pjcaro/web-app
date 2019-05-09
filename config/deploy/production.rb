set :branch, 'master'
set :deploy_to, '/home/deploy/webapp'
set :rvm_ruby_version, '2.5.1@webapp'

server "50.116.42.99", user: "deploy", roles: %w{app db web}