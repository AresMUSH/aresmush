module AresMUSH
  module Custom

    def self.is_item?(item)
      item_name = item.titlecase
      is_item = Global.read_config("magic-items", item_name)
    end

    def self.find_item (char, item_name)
      char.magic_items.select { |a| a.name == item_name }.first
    end

  end
end
