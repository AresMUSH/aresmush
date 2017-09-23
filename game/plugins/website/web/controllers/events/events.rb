module AresMUSH
  class WebApp
    
    helpers do
      def can_manage_event?(event)
        @user && Events.can_manage_event(@user, event)
      end
    end
      
    get '/events/?' do
      @events = Event.sorted_events              
      erb :"events/events_index"
    end
    
    get '/events/ical/?' do
      send_file Events.ical_path
    end
    
    get '/event/create/?' do 
      erb :"events/create_event"
    end
    
    get '/event/:id/edit/?', :auth => :approved do |id|
      @event = Event[id]
      
      if (!@event)
        flash[:error] = "That event doesn't exist."
        redirect '/events'
      end
      
      if (!Events.can_manage_event(@user, @event))
        flash[:error] = "You can't update that event."
        redirect "/event/#{id}"
      end
      
      @page_title = "#{@event.title} - #{game_name}"
      
      erb :"events/edit_event"
    end
    
    post '/event/:id/edit/?', :auth => :approved do |id|
      @event = Event[id]
      
      if (!@event)
        flash[:error] = "That event doesn't exist."
        redirect '/events'
      end
      
      if (!Events.can_manage_event(@user, @event))
        flash[:error] = "You can't update that event."
        redirect "/event/#{id}"
      end
      
      date = params[:date]
      time = params[:time]
      desc = format_input_for_mush params[:description]
      title = params[:title]
      
      if (title.blank? || desc.blank?)
        flash[:error] = "Title and description are required."
        redirect "/event/#{id}/edit"
      end
      
      begin
        datetime = OOCTime.parse_datetime("#{date} #{time}".strip.downcase)
      rescue Exception => ex
        flash[:error] = "Invalid date: #{ex}"
        redirect "/event/#{id}/edit"
      end
      
      Events.update_event(@event, @user, title, datetime, desc)
      redirect "/event/#{id}"
    end
    
    
    get '/event/:id/delete/?', :auth => :approved do |id|
      @event = Event[id]
      
      if (!@event)
        flash[:error] = "That event doesn't exist."
        redirect '/events'
      end
      
      if (!Events.can_manage_event(@user, @event))
        flash[:error] = "You can't update that event."
        redirect "/event/#{id}"
      end
      
      Events.delete_event(@event, @user)             
      flash[:info] = "Event deleted."
      redirect '/events'
    end
    
    post '/event/create', :auth => :approved do
      date = params[:date]
      time = params[:time]
      desc = format_input_for_mush params[:description]
      title = params[:title]
      
      if (title.blank? || desc.blank?)
        flash[:error] = "Title and description are required."
        redirect "/event/create"
      end
      
      begin
        datetime = OOCTime.parse_datetime("#{date} #{time}".strip.downcase)
      rescue Exception => ex
        flash[:error] = "Invalid date: #{ex}"
        redirect '/event/create'
      end
      
      event = Events.create_event(@user, title, datetime, desc)
      redirect "/event/#{event.id}"
    end
    
    
    get '/event/:id/?' do |id|
      @event = Event[id]
      
      if (!@event)
        flash[:error] = "That event doesn't exist."
        redirect '/events'
      end
      
      @page_title = "#{@event.title} - #{game_name}"
      erb :"events/event"
    end
    
  end
end
