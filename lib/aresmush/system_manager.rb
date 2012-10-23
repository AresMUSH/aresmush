require 'ansi'

module AresMUSH
  class SystemManager
    def initialize(config_reader, client_monitor)
      @config_reader = config_reader
      @client_monitor = client_monitor
      @systems = []
    end

    def load_all
      system_files = Dir[File.join(Dir.pwd + "/systems/**/*.rb")]
      SystemManager.load_system_code(system_files)
      create_system_classes
    end
    

    # TODO!!!  This doesn't handle a new module properly
    def self.reload(name)
      system_files = Dir[File.join(Dir.pwd + "/systems/#{name}/**/*.rb")]
      load_system_code(system_files)
    end
      
    
    def self.load_system_code(files)
      files.each do |f| 
        puts "Including" + f
        begin
           load f
        rescue 
           puts "Error loading " + f
        end
      end
    end 
    
    def create_system_classes
      systems = AresMUSH::Commands.constants.select {|c| Class === AresMUSH::Commands.const_get(c).new(@config_reader, @client_monitor)}
      puts systems.count
      systems.each do |s|
        puts "foo"
        #puts "Loading #{s.to_s}"
      end
    end
    
  end
end