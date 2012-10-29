require 'eventmachine'

module AresMUSH

  class CommandLine

    def initialize(server)
      @server = server
    end
    
    # TODO: Add specs
    def start
      @server.start
    end
    
    def migrate
     Sequel.extension :migration, :core_extensions
     Sequel::Migrator.apply(db, File.join(Dir.pwd, "db"))
    end
    
  end
end