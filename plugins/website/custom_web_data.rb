module AresMUSH
  module Website
    # Gets custom fields for the sidebar.
    #
    # @param [Character] viewer - The character viewing the sidebar. May be nil if someone is viewing
    #    the web portal without being logged in.
    #
    # @return [Hash] - A hash containing custom fields and values. 
    #    Ansi or markdown text strings must be formatted for display.
    # @example
    #    return { your_field: your_data }
    #
    #    NOTE!! The sidebar is called A LOT because it's on every page, so be very mindful
    #    about performance. Avoid intensive database queries here.
    def self.custom_sidebar_data(viewer)
      return {}
    end
  end
end