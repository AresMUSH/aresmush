module AresMUSH
  class WebApp
    get '/' do
      @plugins = Plugins.all_plugins
      erb :index
    end
  end
end
