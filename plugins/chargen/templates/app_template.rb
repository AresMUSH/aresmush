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
        ability_system = Global.read_config("chargen", "ability_system")
        return false if ability_system.blank?
        return FS3Skills.is_enabled? if ability_system == 'fs3'
        return true
      end
      
      def abilities
        ability_system = Global.read_config("chargen", "ability_system")
        return nil if ability_system.blank?
        
        case ability_system
        when "fs3"
          FS3Skills.app_review(@char)
        else
          plugin_module = Global.plugin_manager.plugins.select { |p| "#{p}".upcase == "ARESMUSH::#{ability_system.upcase}"}.first
          if (!plugin_module)
            raise "Invalid ability system configured.  No plugin found for #{ability_system}."
          end
          plugin_module.app_review(@char)
        end
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