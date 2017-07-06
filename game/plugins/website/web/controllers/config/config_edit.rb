module AresMUSH
  class WebApp
    
    get '/admin/config/edit', :auth => :admin do
      
      @path = params[:path]
      @plugin = params[:plugin]
      @config = File.read(File.join(AresMUSH.game_path, @path))
      @error = nil      
      @return_url = params[:return_url] || '/admin/config'
      
      begin
        if (@path.end_with?(".yml"))
          YAML::load(@config)
        end
      rescue Exception => ex
        @error = "There's a problem with the format of your YAML file.  See the <a href=\"http://www.aresmush.com/tutorials\">Troubleshooting YAML tutorial</a> for help.  Error: #{ex}"
      end
      
      erb :"admin/config"
    end
    
  end
end
