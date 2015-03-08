module AresMUSH
  module Chargen
    # The stock FS3 chargen lets you jump around between the stages to your heart's content.
    # The 'app' command shows them anything they've missed.
    # On some games, it may be necessary to make sure the player's done something before
    # you let them on to the next stage.  If that's the case with your game, you can 
    # add checks here.
    def self.can_advance?(char)
      # Add 'when' statements for the stages of chargen that need error checks.
      # The name should match the name in the stages list.
      case Chargen.stage_name(char)
      when "demographics"
        return ChargenStageLocks.check_demographics(char)
      else
        return nil
      end
    end
    
    module ChargenStageLocks
      # Define your check methods here.  Return 'nil' if everything's OK, or an error
      # message (which will be shown to the player) if something's wrong.
      def self.check_demographics(char)
        return nil
      end
    end
  end
end