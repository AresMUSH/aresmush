module AresMUSH
  class WebApp

    get '/who/?' do
      connector = AresMUSH::EngineApiConnector.new
      @who =  connector.who.map { |n| Character.find_one_by_name(n) }
      @scenes = Scene.all.select { |s| !s.completed }
      erb :"who"
    end

  end
end