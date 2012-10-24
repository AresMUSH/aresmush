require 'ansi'

module AresMUSH
  class SystemManager
    def initialize(system_factory)
      @system_factory = system_factory
      @systems = []
    end
    
    attr_reader :systems

    def load_all
      system_files = Dir[File.join(Dir.pwd + "/systems/**/*.rb")]
      load_system_code(system_files)
      @systems = @system_factory.create_system_classes
    end
    

    # TODO!!!  This doesn't handle a new module properly
    def reload(name)
      system_files = Dir[File.join(Dir.pwd + "/systems/#{name}/**/*.rb")]
      load_system_code(system_files)
    end
      
    
    def load_system_code(files)
      files.each do |f| 
        puts "Including" + f
        begin
           load f
        rescue 
           puts "Error loading " + f
        end
      end
    end 
  end
end