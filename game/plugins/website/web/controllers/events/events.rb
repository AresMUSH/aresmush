module AresMUSH
  class WebApp
    
    get '/events' do
      @events = AresMUSH::Events.upcoming_events              
      erb :"events/index"
    end
    
    get '/event/:id' do |id|
      @event = Event[id]
      erb :"events/event"
    end
  end
end
