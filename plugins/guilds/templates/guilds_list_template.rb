module AresMUSH
  module Guilds
    class GuildsListTemplate < ErbTemplateRenderer

      attr_accessor :guilds

      def initialize(guilds)
        @guilds = guilds_list.sort
        super File.dirname(__FILE__) + "/guilds_list.erb"
      end
    end
  end
end
