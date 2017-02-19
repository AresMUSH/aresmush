module AresMUSH
  module Chargen
    class ChargenTemplate < ErbTemplateRenderer
      
      attr_accessor :char
      
      def initialize(char)
        @char = char
        @stage_index = char.chargen_info.current_stage
        @stage = Chargen.stages[Chargen.stage_name(char)]
        @markdown = MarkdownFormatter.new
        super File.dirname(__FILE__) + "/chargen.erb" 
      end
            
      def prev_page_footer
        @stage_index == 0 ? "" : t('chargen.prev_page_footer')
      end
      
      def next_page_footer
        @stage_index >= Chargen.stages.keys.count - 1 ? "" : t('chargen.next_page_footer')
      end
      
      def tutorial
        tutorial_file = @stage["tutorial"]
        contents = tutorial_file ? Chargen.read_tutorial(tutorial_file) : nil
        contents ? @markdown.to_mush(contents) : nil
      end
      
      def help
        help_file = @stage["help"]
        contents = help_file ? Help::Api.get_help(help_file) : nil
        contents ? @markdown.to_mush(contents) : nil 
      end
      
      def separator_needed
        @stage["tutorial"] && @stage["help"]          
      end        
    end
  end
end