module AresMUSH
  module Profile
    def self.render_handle_profile(target, viewer)
      template = HandleProfileTemplate.new(target, viewer)
      template.display
    end
  end
end