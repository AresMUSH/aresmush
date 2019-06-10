module AresMUSH  
  # @engineinternal true
  class Database

    def self.build_url(host_and_port, password)
      "redis://:#{password}@#{host_and_port}"
    end

    def load_config
      password = Global.read_config("secrets", "database", "password")
      host_and_port = Global.read_config("database", "url")
      redis_url = Database.build_url(host_and_port, password)
      Global.logger.info("Database config: #{host_and_port}")
      
      begin
        Ohm.redis = Redic.new(redis_url)
                    
      rescue Exception => e
        Global.logger.fatal("Error loading database config.  Please check your dabase configuration and installation requirements: #{e}.")      
        raise e
      end      
    end  
  
    # This removes the object from a set, usually before it's being deleted.
    # For example:  Database.remove_from_set(channel.characters, some_char) will remove the
    # character from a channel's list of characters, if present.
    def self.remove_from_set(set, obj)
      if set.include?(obj)
        set.delete obj
      end
    end     
  end
end