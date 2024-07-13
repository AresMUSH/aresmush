module AresMUSH
  module Jobs
    # Gets custom fields for use in the jobs menu
    #
    # @param [Job] job - The job being requested.
    # @param [Character] viewer - The character viewing the job. 
    #
    # @return [Hash] - A hash containing custom fields and values. 
    #    Ansi or markdown text strings must be formatted for display.
    #    Return an empty hash if you don't need data
    # @example
    #    return { abilities: YourCustomPlugin.build_abilities_list }
    def self.custom_job_menu_fields(char, viewer)
      return {}
    end    
  end
end