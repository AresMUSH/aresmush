module AresMUSH
  module Ranks
    class RanksTemplate < ErbTemplateRenderer
      include TemplateFormatters
      
      attr_accessor :config, :name
      
      def initialize(config, name)
        @config = config
        @name = name
        super File.dirname(__FILE__) + "/ranks.erb"
      end
    end
  end
end