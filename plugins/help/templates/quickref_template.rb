module AresMUSH
  module Help
    class QuickrefTemplate < ErbTemplateRenderer


      attr_accessor :main_list, :manage_list, :formatter
      
      def initialize(main_list, manage_list)
        @main_list = main_list.sort
        @manage_list = manage_list.sort
        @formatter =  MarkdownFormatter.new

        
        super File.dirname(__FILE__) + "/quickref.erb"
      end
      
      def format_line(line)
        @formatter.to_mush(line).strip
      end
    end
  end
end
