module AresMUSH
  class WebApp
    get '/admin/logs', :auth => :admin do
      @logs = Dir[File.join(AresMUSH.game_path, "logs", "**")]
      erb :"admin/logs_index"
    end
    
    get '/admin/log/:file', :auth => :admin do |file|
      @lines = File.readlines(File.join(AresMUSH.game_path, "logs", file)).reverse
      erb :"admin/log"
    end
  end
end