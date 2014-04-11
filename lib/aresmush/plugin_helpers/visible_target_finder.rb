module AresMUSH
  class VisibleTargetFinder
    def self.find(name, client)
      return FindResult.new(client.char, nil) if (name.downcase == "me")
      return FindResult.new(client.room, nil) if (name.downcase == "here")

      chars = Character.where(:room => client.room, :name_upcase => name.upcase)
      exits = Exit.where(:source => client.room, :name_upcase => name.upcase)
      contents = [chars, exits].flatten(1).select { |c| !c.nil? }   
            
      SingleResultSelector.select(contents)
    end
    
    def self.with_something_visible(name, client, &block)
      result = VisibleTargetFinder.find(name, client)
      
      if (!result.found?)
        client.emit_failure(result.error)
        return
      end
      
      yield result.target
    end
  end
end