server 'fairpay.org.au', port: 22, roles: [:web, :app, :db], primary: true

set :repo_url,    'git@github.com:kimgb/underpayments.git'
set :branch,      'master'
set :application, 'underpaid'
set :user,        'deploy'
set :puma_threads, [4, 16]
set :puma_workers, 0

# Don't change these unless you know what you're doing
set :pty,         true
set :use_sudo,    false
set :stage,       :production
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
  
  namespace :migrations do
    desc "Migrates claims from legacy award:string column to award:references replacement."
    task :claims_awards do
      before :publishing do
        execute :rake, "claims:migrate_award_column"
      end
    end
  end
  
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
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

namespace :db do
  desc "Mirror production db to local development"
  task :mirror do
    on roles(:app) do
      # deploy user needs corresponding psql user with .pgpass based access
      run_locally { execute "ssh fairpay.org.au \"pg_dump underpaid\" >> 'underpaid-db-'$(date '+%Y%m%d%H%M%S')" }
    end
  end
end

namespace :setup do
  desc "Upload Figaro application.yml file."
  task :upload_app_config do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      upload! StringIO.new(File.read("config/application.yml")), "#{shared_path}/config/application.yml"
    end
  end
  
  desc "Seed the database."
  task :seed_db do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: :production do
          execute :rake, "db:seed"
        end
      end
    end
  end
  
  desc "Symlinks config files for Nginx."
  task :symlink_nginx do
    on roles(:app) do
      execute "rm -f /etc/nginx/sites-enabled/default"
      
      execute "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{fetch(:application)}"
    end
  end
end

# ps aux | grep puma   # Get puma pid
# kill -s SIGUSR2 pid  # Restart puma
# kill -s SIGTERM pid  # Stop puma
