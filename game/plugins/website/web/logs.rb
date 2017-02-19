module AresMUSH
  class WebApp
    get '/logs', :auth => :admin do
      @logs = Dir[File.join(AresMUSH.game_path, "logs", "**")]
      erb :logs_index
    end
    
    get '/log/:file', :auth => :admin do |file|
      @lines = File.readlines(File.join(AresMUSH.game_path, "logs", file)).reverse
      erb :log
    end
  end
end