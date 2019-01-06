module AresMUSH
  module Manage
    class ConfigCronTemplate < ErbTemplateRenderer
      
      attr_accessor :crons
      
      def initialize(crons)
        @crons = crons
        super File.dirname(__FILE__) + '/config_cron.erb'
      end
    end
  end
end