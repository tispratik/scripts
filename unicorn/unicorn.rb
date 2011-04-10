APP_PATH = "/home/<deployment_user>/public_html/<app_name>"
listen 3000
worker_processes 4
pid 	    "#{APP_PATH}/shared/pids/unicorn.pid"
stderr_path "#{APP_PATH}/shared/log/unicorn.stderr.log"
stdout_path "#{APP_PATH}/shared/log/unicorn.stdout.log"
