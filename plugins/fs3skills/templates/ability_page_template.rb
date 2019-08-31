module AresMUSH
  module FS3Skills
    class AbilityPageTemplate < ErbTemplateRenderer


      attr_accessor :data
      
      def initialize(file, data)
        @data = data
        super File.dirname(__FILE__) + file
      end
      
      def page_footer
        footer = t('pages.page_x_of_y', :x => @data[:page], :y => @data[:num_pages])
        template = PageFooterTemplate.new(footer)
        template.render
      end
      
      def attr_blurb
        FS3Skills.attr_blurb
      end
      
      def advantages_blurb
        FS3Skills.advantages_blurb
      end
      
      def action_blurb
        FS3Skills.action_blurb
      end
      
      def bg_blurb
        FS3Skills.bg_blurb
      end
      
      def lang_blurb
        FS3Skills.language_blurb
      end

      def languages
        lines = []
        column_width = 18
        items_per_line = 78 / column_width
        count = 0
        current_line = ""
            
        @data[:skills].each do |i|
          if (count % items_per_line == 0)
            lines << current_line
            current_line = ""
          end
        current_line << i['name'].truncate(column_width - 1).ljust(column_width)
        count = count + 1
        end

       lines.join "\n"
      end
    end
  end
end
