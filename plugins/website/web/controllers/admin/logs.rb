module AresMUSH
  class WebApp
    get '/admin/logs/?', :auth => :admin do
      @web_logs = Dir[File.join(AresMUSH.game_path, "logs", "web", "**")].sort.reverse
      @engine_logs = Dir[File.join(AresMUSH.game_path, "logs", "engine", "**")].sort.reverse
            
      latest_log = File.readlines(@web_logs[0]).to_s
      latest_log << File.readlines(@engine_logs[0]).to_s
      @error_alert = (latest_log =~ /ERROR/) || (latest_log =~ /WARN/)
      erb :"admin/logs_index"
    end
    
    get '/admin/log/:dir/:file/?', :auth => :admin do |dir, file|
      @name = file
      @lines = File.readlines(File.join(AresMUSH.game_path, "logs", dir, file)).reverse
      erb :"admin/log"
    end
  end
end