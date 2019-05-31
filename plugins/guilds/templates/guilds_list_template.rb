module AresMUSH
  module Guilds
    class GuildsListTemplate < ErbTemplateRenderer

      attr_accessor :data

      def initialize(data)
        @guilds = data
        super File.dirname(__FILE__) + "/guilds_list.erb"
      end
    end
  end
end
