module AresMUSH
  module Events
    class TeamupEvent
      attr_accessor :event
      
      def initialize(event)
        @event = event
      end
      
      def title
        @event['title'] || ""
      end
      
      def starts
        time = @event['start_dt']
        time ? DateTime.strptime(time, '%Y-%m-%dT%H:%M:%S%Z' ) : nil
      end
      
      def start_time_standard
        timezone = Global.read_config("events", "calendar_timezone")
        format = Global.read_config("date_and_time", "time_format")
        formatted_time = starts.strftime(format).strip
        "#{formatted_time} #{timezone}"
      end
      
      def all_day
        @event['all_day'] || false
      end
      
      def location
        @event['location'] || ""
      end
      
      def who
        @event['who'] || ""
      end
      
      def notes
        markdown = MarkdownFormatter.new
        
        notes = @event['notes']
        if (notes)
          p = HTMLPage.new :contents => notes
          notes = markdown.to_mush(p.markdown)
        else
          notes = ""
        end
        notes
      end
      
      def start_time_local(enactor)
        time = self.starts
        local_time = OOCTime::Api.local_long_timestr(enactor, time.to_time)
        notice = self.all_day ? " (#{t('events.all_day')})" : ""
        "#{local_time}#{notice}"
      end
      
      def start_datetime_standard
        time = self.starts
        formatted_time = time.to_time.strftime "%a %b %d, %Y %l:%M%P"
        notice = self.all_day ? " (#{t('events.all_day')})" : ""
        timezone = Global.read_config("events", "calendar_timezone")
        "#{formatted_time}#{notice} #{timezone}"
      end
      
    end
    
    class TeamupApi
      def get_events(startDate, endDate)
        begin
          response = get("#{calendar}/events", { "startDate" => startDate, "endDate" => endDate})
          Global.logger.debug "Got response from calendar server."
          response ? response['events'].map { |e| TeamupEvent.new(e) } : []
        rescue Exception => ex
          Global.logger.warn "Unable to contact calendar server: #{ex}"
          []
        end
      end

      def api_key
        Global.read_config("secrets", "events", "api_key")
      end
      
      def calendar
        Global.read_config("secrets", "events", "calendar")
      end
      
      def build_uri(action)
        url = "https://api.teamup.com/#{action}"
        URI.parse(url)
      end

      def get(action, params)
         uri = build_uri(action)
         uri.query = URI.encode_www_form(params)

         req = Net::HTTP::Get.new(uri)
         req['Teamup-Token'] = api_key

         res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') {|http|
           resp = http.request(req)           
           return JSON.parse(resp.body)
         }
      end
    end
  end
end