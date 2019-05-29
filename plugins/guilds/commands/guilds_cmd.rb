module AresMUSH
  module Guilds
    class GuildsCmd
      include CommandHandler

      def handle
        guilds_list = Guilds.all_guilds
        template = GuildsListTemplate.new guilds
        client.emit template.render
      end
    end
  end
end
