module AresMUSH
  module Manage
    class ServerTemplate < ErbTemplateRenderer
      
      attr_accessor :migrator
      
      def initialize
        @migrator = DatabaseMigrator.new
        super File.dirname(__FILE__) + '/server.erb'
      end
      
      def server_version
        AresMUSH.version
      end
      
      def webportal_version
        Website.webportal_version
      end
      
      def migrations
        @migrator.read_applied_migrations.map { |m| m.gsub("_update", "")}
      end
      
      def num_characters
        Character.all.count
      end
      
      def num_rooms
        Room.all.count
      end
      
      def num_exits
        Exit.all.count
      end
      
      def server_started
        Global.server_start
      end
      
      def server_uptime
        TimeFormatter.format Time.now - Global.server_start
      end
    end
  end
end