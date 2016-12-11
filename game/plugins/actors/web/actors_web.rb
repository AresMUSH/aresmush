module AresMUSH
  class WebApp
    # Request runs on the reactor thread (with threaded set to false)
    get '/actors' do
      erb :actors
    end
  end
end
