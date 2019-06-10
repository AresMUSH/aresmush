module AresMUSH
  module Chargen
    class AppTemplate < ErbTemplateRenderer
      
      attr_accessor :char
      
      def initialize(char, enactor)
        @char = char
        @enactor = enactor
        super File.dirname(__FILE__) + "/app.erb" 
      end
      
      def section_title(title)
        title = " #{title} ".center(78, '-')
        "%x!%xh#{title}%xH%xn%r"
      end
      
      def abilities
        FS3Skills.app_review(@char)
      end
      
      def demographics
        Demographics.app_review(@char)
      end
       
      def bg
        Chargen.bg_app_review(@char)
      end
       
      def desc
        Describe.app_review(@char)
      end
     
      def ranks
        Ranks.app_review(@char)
      end
      
      def hooks
        Chargen.hook_app_review(@char)
      end
      
      def custom
        Chargen.custom_app_review(@char)
      end
      
      def show_custom
        !!custom
      end
      
     
      def job_info
        job = @char.approval_job
        if (job)
          id =job.id
          if (@enactor == @char)
            return t('chargen.app_request', :job => id)
          else
            return t('chargen.app_job', :job => id)
          end
        else
          return t('chargen.app_not_started')
        end
      end
    end
  end
end