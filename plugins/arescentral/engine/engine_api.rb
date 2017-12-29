module AresMUSH
  class EngineApiServer
    
    helpers do 
      def check_api_key
        params[:api_key] == Game.master.engine_api_key
      end
      
      def format_mush(text)
        text = MushFormatter.format(text, false)
        return AnsiFormatter.strip_ansi(text)
      end
      
      def format_markdown_for_html(output)
        return nil if !output
        
        allow_html = Global.read_config('website', 'allow_html_in_markdown')
        text = AresMUSH::MushFormatter.format output, false
        text = AnsiFormatter.strip_ansi(text)
        html_formatter = AresMUSH::Website::WikiMarkdownFormatter.new(!allow_html, self)
        text = html_formatter.to_html text
        text
      end
      
      def icon_for_char(char)
        if (char)
          icon = char.profile_icon
          if (icon.blank?)
            icon = char.profile_image
          end
        else
          icon = nil
        end
        
        icon.blank? ? nil : icon
      end
    end
    
    get '/wikis/?' do
      content_type :json

      name_or_id = params[:name]
      if (!name_or_id)
        name_or_id = 'home'
      end
      
      if (name_or_id =~ / /)
        name = "/wiki/#{name_or_id.gsub(' ', '-').downcase}"
      end
      
      page = WikiPage.find_by_name_or_id(name_or_id)
      if (!page)
        return { error: 'Page not found.'}.to_json
      end
              
      dynamic_page = Website::WikiMarkdownExtensions.is_dynamic_page?(page.text)
         
      # Update cached version.      
      #if (page.html && !dynamic_page)
      #  page_html = page.html
      #else
        page_html = format_markdown_for_html page.text
        page.update(html: page_html)
        #end
            
      {
        id: page.id,
        title: page.title,
        name: page.name,
        html: page_html
      }.to_json
    end
    
    
    get '/characters/?' do
      content_type :json
      data = Idle.active_chars.map { |c| {
        type: 'character',
        id: c.id,
        name: c.name,
        fullname: c.demographic('Fullname'),
        rank: c.rank,
        faction: c.group('Faction'),
        position: c.group('Position'),
        age: c.age,
        played_by: c.actor,
        profile_image: c.profile_image,
        gender: c.demographic('gender')        
        }
      }
      data.to_json
    end
    
    get '/events' do 
      content_type :json
      data = Events.upcoming_events.map { |e| {
        title: e.title,
        id: e.id,
        description: e.description,
        starts: e.start_datetime_standard,
        organizer: e.character.name
      }}
      data.to_json
    end
    
    get '/events/:event_id' do |event_id|
      content_type :json
      event = Event[event_id]
      if (!event)
        return {}.to_json
      end
      
      data = {
        title: event.title,
        id: event.id,
        description: event.description,
        starts: event.start_datetime_standard,
        organizer: event.character.name
      }
      data.to_json
    end
    
    get '/characters/:id' do |id|
      content_type :json
      
      c = Character[id]
      {
        type: 'character',
        id: c.id,
        name: c.name,
        fullname: c.demographic('Fullname'),
        rank: c.rank,
        faction: c.group('Faction'),
        position: c.group('Position'),
        age: c.age,
        played_by: c.actor,
        profile_image: c.profile_image,
        gender: c.demographic('gender'),
        damage: c.damage.map { |d| { date: d.ictime_str, 
          description: d.description, 
          severity: format_mush(FS3Combat.display_severity(d.initial_severity)) }},
        background: format_mush(c.background)
      }.to_json
    end
    
    get '/api/who' do 
      who = Global.client_monitor.logged_in.map { |client, char| char.name }
      { who: who }.to_json
    end
      
    post '/api/char/created' do
      Global.dispatcher.queue_event CharCreatedEvent.new(nil, params['id'])
      { status: 'OK', error: '' }.to_json
    end
    
    post '/api/notify' do
      if (!check_api_key)
        return { status: 'ERROR', error: 'Invalid authentication token.'}.to_json
      end

      type = params['type']
      char_ids = (params['chars'] || '').split(',')
      msg = params['message']
      ooc = params['ooc'].to_bool

      if (ooc)
        Global.notifier.notify_ooc(type, msg) do |char|
          char && char_ids.include?(char.id)
        end
      else
        Global.notifier.notify(type, msg) do |char|
          char && char_ids.include?(char.id)
        end
      end      
      {status: 'OK'}.to_json
    end
    
    post '/api/char/created' do
      Global.dispatcher.queue_event CharCreatedEvent.new(nil, params['id'])
      { status: 'OK', error: '' }.to_json
    end
    
    post '/api/config/load' do
      
      if (!check_api_key)
        return { status: 'ERROR', error: 'Invalid authentication token.'}.to_json
      end
      
      error = Manage.reload_config
      { status: error ? 'ERROR' : 'OK', error: error }.to_json            
    end
    
    post '/api/tinker/load' do
      if (!check_api_key)
        return { status: 'ERROR', error: 'Invalid authentication token.'}.to_json
      end

      error = nil
      begin
        begin
          Global.plugin_manager.unload_plugin("tinker")
        rescue SystemNotFoundException
          # Swallow this error.  Just means you're loading a plugin for the very first time.
        end
        # Make sure everything is valid before we start.
        Global.config_reader.validate_game_config          
        Global.plugin_manager.load_plugin("tinker", :engine)
        Global.config_reader.load_game_config        
      rescue Exception => ex
        Global.logger.error ex
        error = ex.to_s
      end
      { status: error ? 'ERROR' : 'OK', error: error }.to_json      
    end

    post '/api/char/created' do
      if (!check_api_key)
        return { status: 'ERROR', error: 'Invalid authentication token.'}.to_json
      end
      
      Global.dispatcher.queue_event CharCreatedEvent.new(nil, params['id'])
      { status: 'OK', error: '' }.to_json
    end
    
    post '/api/plugins/changed' do
      if (!check_api_key)
        return { status: 'ERROR', error: 'Invalid authentication token.'}.to_json
      end

      changed = params['changed_plugins'].split(",")
      
      begin
        # Make sure everything is valid before we start.
        Global.config_reader.validate_game_config          
        Global.config_reader.load_game_config   
        changed.each do |p|
          begin
            Global.plugin_manager.unload_plugin(p)
          rescue SystemNotFoundException
            # Swallow this error.  Just means you're loading a plugin for the very first time.
          end
          Global.plugin_manager.load_plugin(p, :engine)
        end      
        Help.reload_help
        Global.locale.reload
        Global.dispatcher.queue_event ConfigUpdatedEvent.new
      rescue Exception => ex
        Global.logger.error ex
        error = ex.to_s
      end
      { status: error ? 'ERROR' : 'OK', error: error }.to_json   
    end

  end
end