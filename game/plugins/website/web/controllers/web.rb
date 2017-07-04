module AresMUSH
  class WebApp    
    attr_accessor :user
    
    configure do
      disable :show_exceptions      
    end
    
    before do
      user_id = session[:user_id]
      @user = user_id ? Character[user_id] : nil
      
      if (@user && @user.login_api_token_expiry < Time.now)
        flash[:error] = "Your session has expired.  Please log in again."
        session.clear
        redirect to('/')
      end
      
      @recaptcha = AresMUSH::Website::RecaptchaHelper.new
    end
    
    error do
      Global.logger.error env['sinatra.error']
      @error = env['sinatra.error'].message
      erb :"error"
    end
    
    helpers do
      def is_user?
        @user != nil
      end
      
      def enable_registration
        return Global.read_config("login", "allow_web_registration")
      end
      
      def is_admin?
        @user != nil && @user.is_admin?
      end
      
      def is_approved?
        @user != nil && (@user.is_approved? || @user.is_admin?)
      end

      def game_name
        AresMUSH::Global.read_config('game', 'name' )
      end
      
      def game_website
        AresMUSH::Global.read_config('game', 'website' )
      end
      
      def game_address
        host = AresMUSH::Global.read_config('server', 'hostname' )
        port = AresMUSH::Global.read_config('server', 'port' )
        "#{host} port #{port}"
      end

      # Takes something from a text box and replaces carriage returns with %r's for MUSH.
      def format_input_for_mush(input)
        return nil if !input
        input.gsub(/\r\n/, '%r')
      end

      # Takes MUSH text and formats it for a text box with %r's becoming line breaks.      
      def format_input_for_html(input)
        return nil if !input
        input.gsub(/%r/i, '&#013;&#010;')
      end
      
      # Takes MUSH text and formats it for display in a div, with %r's becoming HTML breaks.
      def format_output_for_html(output)
        return nil if !output
        text = AresMUSH::ClientFormatter.format output, false
        text.strip.gsub(/[\r\n]/i, '<br/>')
      end
      
      def format_markdown_for_html(output)
        renderer = Redcarpet::Render::HTML.new(escape_html: true, hard_wrap: true, 
              autolink: true, safe_links_only: true)    
        html = Redcarpet::Markdown.new(renderer)
        text = html.render output
        format_output_for_html(text)
      end
      
      def titlecase_arg(input)
        return nil if !input
        input.titlecase
      end
      
      def write_config_file(path, config)
        File.open(path, 'w') do |f|
          f.write(config)
        end
      end

    end

    get '/' do
      @events = Events::Api.upcoming_events
      @calendar = Events.calendar_view_url
      erb :"index"
    end  
    
    get "/play" do
      erb :"play"
    end
    
  end
end
