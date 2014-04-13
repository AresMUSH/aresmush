module AresMUSH
  class AnyTargetFinder
    def self.find(name_or_id, client)
      find_result = VisibleTargetFinder.find(name_or_id, client)
      
      if (find_result.found?)
        return find_result
      end
      
      chars = Character.find_all_by_name_or_id(name_or_id)
      exits = Exit.find_all_by_name_or_id(name_or_id)
      rooms = Room.find_all_by_name_or_id(name_or_id)
      
      contents = [chars, exits, rooms].flatten(1).select { |c| !c.nil? }   
            
      SingleResultSelector.select(contents)
    end
  end
end