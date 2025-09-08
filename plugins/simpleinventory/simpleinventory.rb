$:.unshift File.dirname(__FILE__)

module AresMUSH
     module Simpleinventory

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("simple_inventory", "shortcuts")
    end

    def self.achievements
      Global.read_config('simple_inventory', 'achievements')
    end

    def self.get_cmd_handler(client, cmd, enactor)

      #ITEMS
      case cmd.root
      when "items"
        return ItemsCmd
      end
      case cmd.root
      when "item"
        case cmd.switch
        when "add"
          return ItemAddCmd
        when "equip"
          return ItemEquipCmd
        when "unequip"
          return ItemUnequipCmd
        when "remove"
          return ItemRemoveCmd
        when "give"
          return GiveItemCmd
        when 'buy'
          return BuyItemCmd
        end
      end

      nil
    end



  end
end
