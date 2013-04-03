module AresMUSH
  module Who
    class WhoFormatter

      # TODO - Proof of concept only.  Needs to be reworked into something configurable
      def self.format(logged_in)
        who_list = format_header(logged_in)
        who_list << format_players(logged_in)
        who_list << format_footer(logged_in)
      end
      
      def self.format_players(logged_in)
        players = ""
        logged_in.each do |client|
          players << "\n"
          players << "#{client.player["status"]}".ljust(10)
          players << "#{client.name}".ljust(20)
          players << "#{client.idle}"
        end
        players
      end

      def self.format_header(logged_in)
        header = "%l1\n"
        header << "Status".ljust(10)
        header << "Name".ljust(20)
        header << "Idle"
        header
      end

      def self.format_footer(logged_in)
        ic_people = logged_in.select { |client| Who.is_ic?(client.player) }
        footer = "\n\n"
        footer << "#{logged_in.count} Online -- #{ic_people.count} IC"
        footer << "\n%l1"
        footer
      end

    end
  end
end