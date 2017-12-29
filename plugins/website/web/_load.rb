$:.unshift File.dirname(__FILE__)

load "controllers/admin/admin.rb"
load "controllers/admin/shutdown.rb"
load "controllers/admin/logs.rb"

load "controllers/config/config.rb"
load "controllers/config/config_edit.rb"
load "controllers/config/config_update.rb"
load "controllers/config/config_date.rb"
load "controllers/config/config_plugins.rb"
load "controllers/config/config_secrets.rb"
load "controllers/config/config_sites.rb"
load "controllers/config/config_skin.rb"
load "controllers/config/config_names.rb"
load "controllers/config/config_game_info.rb"
load "controllers/config/config_web.rb"
load "controllers/config/config_webfiles.rb"

load "controllers/wiki/edit_create_page.rb"
load "controllers/wiki/wiki.rb"

load "controllers/session.rb"
load "controllers/web.rb"
load "controllers/formatters.rb"
load "controllers/files.rb"

