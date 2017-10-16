module AresMUSH
  class WebApp
    helpers do
      def tinker_cmd_path
        File.join(AresMUSH.plugin_path, 'tinker', 'lib', 'tinker_cmd.rb')
      end
    end
    
    get '/admin/?', :auth => :admin do
      @reboot_required = File.exist?('/var/run/reboot-required')
      erb :"admin/admin_index"
    end
    
  end
end
