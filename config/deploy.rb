server 'robbed.nuw.org.au', port: 22, roles: [:web, :app, :db], primary: true

set :stages, ["staging", "production"]
set :default_stage, "staging"

set :repo_url,    'git@github.com:kimgb/underpayments.git'
set :user,        'deploy'
set :puma_threads, [4, 16]
set :puma_workers, 0

# Don't change these unless you know what you're doing
set :pty,         true
set :use_sudo,    false
set :deploy_via,  :remote_cache
set :deploy_to,   "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :ssh_options, { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }

set :rbenv_type,  :user
set :rbenv_ruby,  File.read('.ruby-version').strip

set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

set :puma_bind,               "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,              "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,                "#{shared_path}/tmp/pids/puma.pid"
set :puma_error_log,          "#{release_path}/log/puma.error.log"
set :puma_access_log,         "#{release_path}/log/puma.access.log"
set :puma_preload_app,        true
set :puma_worker_timeout,     nil
set :puma_init_active_record, true

## Defaults
# set :scm, :git
# set :branch, :master
# set :format, :pretty
# set :log_level, :debug
# set :keep_releases, 5

## Linked Files & Directories (Default None):
set :linked_files, %w{config/application.yml}
set :linked_dirs, %w{public/uploads public/system}

# Clear existing task so we can replace it rather than "add" to it.
Rake::Task["deploy:compile_assets"].clear 

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  # Customised for local precompile, to get around low RAM servers (e.g. 512MB)
  desc 'Compile assets'
  task :compile_assets => [:set_rails_env] do
    # invoke 'deploy:assets:precompile'
    invoke 'deploy:assets:precompile_local'
    invoke 'deploy:assets:backup_manifest'
  end

  namespace :assets do
    desc "Precompile assets locally and then rsync to web servers" 
    task :precompile_local do 
      # compile assets locally
      run_locally do
        execute "RAILS_ENV=#{fetch(:stage)} bundle exec rake assets:precompile"
      end

      # rsync to each server
      local_dir = "./public/assets/"
      on roles( fetch(:assets_roles, [:web]) ) do
        host.user = fetch(:user)
        # this needs to be done outside run_locally in order for host to exist
        remote_dir = "#{host.user}@#{host.hostname}:#{release_path}/public/assets/"
    
        run_locally { execute "rsync -av --delete #{local_dir} #{remote_dir}" }
      end

      # clean up
      # run_locally { execute "rm -rf #{local_dir}" }
      run_locally { execute :bundle, "exec rake assets:clobber" }
    end
  end
  
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,    :check_revision
  after  :finishing,   :compile_assets
  after  :finishing,   :cleanup
  after  :finishing,   :restart
end

# ps aux | grep puma   # Get puma pid
# kill -s SIGUSR2 pid  # Restart puma
# kill -s SIGTERM pid  # Stop puma
