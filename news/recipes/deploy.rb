search("aws_opsworks_app").each do |app|
  Chef::Log.info("********** The app's short name is '#{app['shortname']}' **********")
  Chef::Log.info("********** The app's URL is '#{app['app_source']['url']}' **********")
  Chef::Log.info("********** data_sources '#{app['data_sources']}' **********")
  Chef::Log.info("********** deploy       '#{app['deploy']}' **********")
  Chef::Log.info("********** environment  '#{app['environment']}' **********")
  Chef::Log.info("********** USER  '#{app['environment'][:DB_USER]}' **********")
  Chef::Log.info("********** PASS  '#{app['environment'][:DB_PASS]}' **********")
  Chef::Log.info("********** DB_NAME  '#{app['environment'][:DB_NAME]}' **********")
end

bash "fetch news" do
  user "deploy"
  cwd node.news.src_path

  code <<-BASH
  if [ ! -d news ]; then
    git clone #{node.news.src_git_url}
    cd news
  else
    cd news
    git reset --hard origin/master
  fi
  BASH
  action :run
end

ENV['HOME'] = node.news.deploy_path
ENV['JAVA_HOME'] = node.news.java_home
bash "pip install package" do
  user "deploy"
  cwd node.news.deploy_path
  #environment node
  code <<-BASH
  export HOME=/home/deploy
  if [ ! -d venv ]; then
    virtualenv venv
  fi
  source venv/bin/activate
  pip install -r src/news/backend/requirements.txt
  BASH
  action :run
end

ENV['HOME'] = node.news.deploy_path
ENV['JAVA_HOME'] = node.news.java_home
bash "run news" do
  user "deploy"
  cwd node.news.deploy_path
  code <<-BASH
  export HOME=/home/deploy
  source venv/bin/activate
  cd src/news/backend
  python manage.py runserver &
  BASH
  action :run
end
