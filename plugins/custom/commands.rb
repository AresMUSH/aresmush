require_relative "set_legendary_attribute_cmd"

module AresMUSH
  module Custom
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "setlegendary"
        return SetLegendaryAttributeCmd
      end
      nil
    end
  end
end
