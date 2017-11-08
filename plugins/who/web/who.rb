module AresMUSH
  class WebApp

    get '/who/?' do
      @who =  Engine.client_monitor.logged_in.map { |client, char| char }
      @scenes = Scene.all.select { |s| !s.completed }
      erb :"who"
    end

  end
end