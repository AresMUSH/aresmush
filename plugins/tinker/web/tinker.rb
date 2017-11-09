module AresMUSH
  class WebApp
    
    helpers do
      def tinker_cmd_path
        File.join(AresMUSH.plugin_path, 'tinker', 'engine', 'tinker_cmd.rb')
      end
      
      def reload_tinker
        connector = AresMUSH::EngineApiConnector.new
        error = connector.reload_tinker
        if (error)
          flash[:error] = error
        else
          flash[:info] = "The tinker code has been updated.  You can now run it in-game with the 'tinker' command."
        end
      end
    end
    
    get '/admin/tinker/?', :auth => :admin do
      @code = File.read(tinker_cmd_path)
      erb :"tinker/tinker"
    end
    
    post '/admin/tinker/reset', :auth => :admin do
      flash[:info] = "The tinker code has been reset to its default value."

      reset_path = File.join(AresMUSH.plugin_path, 'tinker', 'default_tinker.txt')
      FileUtils.cp reset_path, tinker_cmd_path
      reload_tinker
      redirect '/admin/tinker'
    end
    
    post '/admin/tinker/update', :auth => :admin do

      begin
      
        File.open(tinker_cmd_path, 'w') do |f|
          f.write params[:contents]
        end

        reload_tinker
        
      rescue Exception => ex
        flash[:error] = "There was a problem with the tinker code: #{ex}"
      end
      
      redirect '/admin/tinker'
    end
    
  end
end
