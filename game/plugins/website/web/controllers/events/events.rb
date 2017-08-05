module AresMUSH
  class WebApp
    
    get '/events' do
      @events = AresMUSH::Event.sorted_events              
      erb :"events/events_index"
    end
    
    get '/event/:id' do |id|
      @event = Event[id]
      erb :"events/event"
    end
  end
end
