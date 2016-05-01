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

bash "run uwsgi" do
  user "deploy"
  cwd node.news.deploy_path
  code <<-BASH
  export HOME=/home/deploy
  source venv/bin/activate
  cd src/news/backend
  python manage.py loadnews all
  BASH
  action :run
end
