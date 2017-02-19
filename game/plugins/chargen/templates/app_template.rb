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
        FS3Skills::Api.app_review(@char)
      end
      
      def demographics
        Demographics::Api.app_review(@char)
      end
       
      def groups
        Groups::Api.app_review(@char)
      end
       
      def bg
        Chargen.bg_app_review(@char)
      end
       
      def desc
        Describe::Api.app_review(@char)
      end
     
      def ranks
        Ranks::Api.app_review(@char)
      end
     
      def job_info
        job = Chargen.approval_job(@char)
        if (job)
          number =job.number
          if (@enactor == @char)
            return t('chargen.app_request', :job => number)
          else
            return t('chargen.app_job', :job => number)
          end
        else
          return t('chargen.app_not_started')
        end
      end
    end
  end
end
