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
      
      def show_abilities
        return true if FS3Skills.is_enabled?
        return true if Manage.is_extra_installed?("cortex")
        return true if Manage.is_extra_installed?("ffg")
        return true if Manage.is_extra_installed?("fate")
        return false
      end
      
      def abilities
        if (FS3Skills.is_enabled?)
          return FS3Skills.app_review(@char)
        end
        
        if (Manage.is_extra_installed?("cortex"))
          return Cortex.app_review(@char)
        end

        if (Manage.is_extra_installed?("ffg"))
          return Ffg.app_review(@char)
        end

        if (Manage.is_extra_installed?("fate"))
          return Fate.app_review(@char)
        end
        
        return nil
      end
      
      def abilities_header
        Global.read_config("chargen", "ability_system_app_review_header")
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