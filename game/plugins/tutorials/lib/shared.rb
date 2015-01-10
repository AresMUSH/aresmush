module AresMUSH
  module Tutorials
    def self.available_tutorials
      Global.config["tutorials"]["topics"]
    end
    
    def self.is_valid_tutorial?(name)
      Tutorials.available_tutorials.has_insensitive_key?(name)
    end
    
    def self.tutorial_folder(name)
      tutorial = Tutorials.available_tutorials.get_insensitive_value(name)
      tutorial["folder"]
    end
    
    def self.page_files(name)
      tutorial = Tutorials.available_tutorials.get_insensitive_value(name)
      tutorial["pages"]
    end
    
    def self.page_file(name, page_index)
      Tutorials.page_files(name)[page_index]
    end
    
    def self.get_page(char)
      tutorial = char.tutorial.titleize
      page_index = char.tutorial_page_index
      pages = Tutorials.page_files(tutorial)

      return t('tutorials.tutorial_not_started') if !Tutorials.is_valid_tutorial?(tutorial)
      return t('tutorials.tutorial_complete') if (page_index >= pages.count)
                    
      file = File.join(Tutorials.tutorials_dir, Tutorials.tutorial_folder(tutorial), "#{pages[page_index]}")
      
      tutorial_title = t('tutorials.page_title', :tutorial => tutorial).rjust(39)
      topic_title = File.basename(file, ".txt").titleize.ljust(39)
      progress = (((page_index + 1.0)/ pages.count) * 10.0).ceil
      page_count_footer = "#{"@".repeat(progress)}#{".".repeat(10 - progress)}".ljust(20)
      
      begin
        contents = File.read(file, :encoding => "UTF-8")
      rescue
        error_msg = "#{char.name} found a missing tutorial file!%R%R#{file}%R%RPlease tell them when it's fixed."
        Global.logger.error error_msg
        Global.dispatcher.queue_event UnhandledErrorEvent.new(error_msg)
        contents = t('tutorials.file_not_found')
      end
      
      prev_page_footer = (page_index == 0 ? "" : t('tutorials.prev_page_footer')).ljust(29)
      next_page_footer = (page_index >= pages.count - 1 ? "" : t('tutorials.next_page_footer')).rjust(29)
      
      text = 
      "%xh#{topic_title}#{tutorial_title}%xn" +
      "%R%R" +
      "#{contents}" + 
      "%R%l2%R" +
      "%xh#{prev_page_footer}%xn%xh#{page_count_footer}%xn%xh#{next_page_footer}%xn"
      
      text
    end

    def self.tutorials_dir
      File.join(AresMUSH.game_path, "tutorials")
    end
  end
end