set :branch, 'master'
set :deploy_to, '/home/deploy/webapp'
set :rvm_ruby_version, '2.5.1@webapp'

server "http://linode-2.vortexsoftware.com.ar", user: "vortex", roles: %w{app db web}