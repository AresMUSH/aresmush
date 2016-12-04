module AresMUSH
  module FS3Skills
    # Template for an exit.
    class XpTemplate < ErbTemplateRenderer
      include TemplateFormatters
        
      attr_accessor :char
          
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/xp.erb"        
      end
              
      def display(a)
        "#{a.name.ljust(20)} #{progress(a)} #{detail(a)} #{days_left(a)}"
      end
      
      def detail(a)
        can_raise = FS3Skills.can_learn_further?(a.name, a.rating)
        status = can_raise ? "(#{a.xp}/#{a.xp_needed})" : "(---)"
        status.ljust(16)
      end
      
      def days_left(a)
        time_left = (a.time_to_next_learn / 86400).ceil
        message = time_left == 0 ? t('fs3skills.xp_days_now') : t('fs3skills.xp_days', :days => time_left)
        center(message, 13)
      end
      
      def progress(a)
        percent = (a.learning_progress * 10).floor        
        stars = percent.times.collect { "@" }.join
        dots = (10 - percent).times.collect { "." }.join
        "#{stars}#{dots}"
      end
      
    end
  end
end
