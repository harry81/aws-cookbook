bash "migrate" do
  user "deploy"
  cwd node.hoodpub.deploy_path
  code <<-BASH
  export HOME=/home/deploy
  source venv/bin/activate
  cd src/hoodpub/backend
  python manage.py migrate
  BASH
  action :run
end

bash "run uwsgi" do
  user "deploy"
  cwd node.hoodpub.deploy_path
  code <<-BASH
  export HOME=/home/deploy
  source venv/bin/activate
  cd src/hoodpub/backend
  uwsgi --ini uwsgi.ini
  BASH
  action :run
end
