module AresMUSH
  module Guilds
    class GuildsCmd
      include CommandHandler

      def handle
        guilds_list = Guilds.all_guilds
        template = GuildsListTemplate.new guilds_list
        client.emit template.render
      end
    end
  end
end
