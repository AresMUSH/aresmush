module AresMUSH
  module Describe
    # Template for a character.
    class CharacterTemplate < ErbTemplateRenderer
      include CharDescTemplateFields

      attr_accessor :mount

      def initialize(mount)
        @mount = mount
        super File.dirname(__FILE__) + "/mount.erb"
      end

      def details
        names = @mount.details.keys.sort
        names.empty? ? nil : names.join(", ")
      end


    end
  end
end