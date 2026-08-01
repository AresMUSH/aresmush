module AresMUSH
  module AltTracker
    class BanHistoryTemplate < ErbTemplateRenderer

      attr_accessor :char_name, :email, :history

      def initialize(char_name, email, history)
        @char_name = char_name
        @email = email
        @history = history
        super File.dirname(__FILE__) + "/ban_history.erb"
      end

      def format_entry(entry)
        action  = entry['action']  || entry[:action]
        by      = entry['by']      || entry[:by]
        at      = entry['at']      || entry[:at]
        days    = entry['days']    || entry[:days]
        expires = entry['expires'] || entry[:expires]

        timestamp = at ? at.strftime('%Y-%m-%d %H:%M') : "unknown time"

        case action
        when "ban"
          if days
            "BAN by #{by} on #{timestamp} for #{days} day(s) (until #{expires ? expires.strftime('%Y-%m-%d %H:%M') : '?'})"
          else
            "BAN by #{by} on #{timestamp} (permanent)"
          end
        when "unban"
          "UNBAN by #{by} on #{timestamp}"
        else
          "#{action} by #{by} on #{timestamp}"
        end
      end
    end
  end
end
