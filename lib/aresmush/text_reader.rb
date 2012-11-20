module AresMUSH
  class TextReader    
    def initialize(game_dir)
      @txt_path = File.join(game_dir, "txt")
      clear
    end

    attr_accessor :txt

    def clear
      @txt = {}
    end

    def read
      clear_config
      read_text_files
    end
    
    private
    def read_text_files
      Dir.foreach("#{@txt_path}") do |f| 
        file_path = File.join(@txt_path, f)
        next if (File.directory?(file_path))
        file_txt = File.read( file_path ) 
        @txt[File.basename(f, ".*")] = file_txt
      end
    end
  end
end