module AresMUSH
  module Guilds
    class GuildsCmd
      include CommandHandler

      def handle
        guilds = []
        list = Guilds.all_guilds.sort_by { |key| key['name'] }
        list.each do |a|
          if a['is_public'] == true || enactor.is_admin?
            guilds << a
          end
        end
        template = GuildsListTemplate.new guilds
        client.emit template.render
      end
    end
  end
end
