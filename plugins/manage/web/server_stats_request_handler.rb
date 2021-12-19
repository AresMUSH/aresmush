module AresMUSH
  module Manage
    class ServerStatsRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error

        migrator = DatabaseMigrator.new
        
        {
          migrations:  migrator.read_applied_migrations.map { |m| m.gsub("_update", "")},
          num_characters: Character.all.count,
          num_rooms: Room.all.count,
          num_exits: Exit.all.count,
          server_start: Global.server_start,
          server_uptime: TimeFormatter.format(Time.now - Global.server_start),
          plugins: Manage.list_plugins_with_versions,
          mush_version: AresMUSH.version
        }
      end
    end
  end
end