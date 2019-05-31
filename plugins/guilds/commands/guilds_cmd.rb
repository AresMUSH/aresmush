module AresMUSH
  module Guilds
    class GuildsCmd
      include CommandHandler

      def handle
        guilds = Guilds.all_guilds.sort_by { |key| key['name'] }
        template = GuildsListTemplate.new guilds
        client.emit template.render
      end
    end
  end
end
