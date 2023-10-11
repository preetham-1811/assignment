namespace :setup do
  desc "setup: copy config/master.key to shared/config"
  task :copy_linked_master_key do
    on roles([:app]) do
      upload! "config/master.key", "#{shared_path}/config/master.key"
      execute :chmod, "600", "#{shared_path}/config/master.key"
    end
  end
  before "deploy:check:linked_files", "setup:copy_linked_master_key"
end
