module AresMUSH
  module Chargen
    def self.can_approve?(actor)
      actor.has_any_role?(Global.config['chargen']['roles']['can_approve'])
    end
    
    def self.read_tutorial(name)
      dir = File.dirname(__FILE__) + "/../tutorial/"
      filename = File.join(dir, Global.locale.locale.to_s, name)
      File.read(filename, :encoding => "UTF-8")
    end
    
    def self.stages
      Global.config['chargen']['stages']
    end
    
    def self.stage_name(char)
      Chargen.stages.keys[char.chargen_stage]
    end
      
    def self.chargen_display(char)
      stage_index = char.chargen_stage
      display = ""
      
      prev_page_footer = (stage_index == 0 ? "" : t('chargen.prev_page_footer')).ljust(39)
      next_page_footer = (stage_index >= Chargen.stages.keys.count - 1 ? "" : t('chargen.next_page_footer')).rjust(39)
      
      begin
        stage = Chargen.stages[Chargen.stage_name(char)]
        tutorial_file = stage["tutorial"]
        help_file = stage["help"]
      
        if (tutorial_file)
          display << Chargen.read_tutorial(tutorial_file)
        end
        if (tutorial_file && help_file)
          display << "%R%l2%R"
        end        
        if (help_file)
          display << Help.load_help("main", help_file)
        end
        display << "%R%L2%R#{prev_page_footer}#{next_page_footer}"
      rescue
        error_msg = "Error loading chargen tutorial stage #{stage}"
        Global.logger.error error_msg
        Global.dispatcher.queue_event UnhandledErrorEvent.new(error_msg)
        display << t('chargen.error_loading_tutorial')
      end
      
      display
      #Tutorials.get_page_for_tutorial(Chargen.tutorial_name,
      #  char.chargen_stage,
      #  t('chargen.prev_page_footer'),
      #  t('chargen.next_page_footer'),
      #  "TEST%R")
    end
  end
end