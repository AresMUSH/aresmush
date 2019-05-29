module AresMUSH
  module Guilds
    class GuildsListTemplate < ErbTemplateRenderer

      attr_accessor :guilds

      def initialize(guilds_list)
        @guilds = guilds
        super File.dirname(__FILE__) + "/guilds_list.erb"
      end
    end
  end
end
