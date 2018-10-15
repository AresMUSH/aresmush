module AresMUSH
  module Custom

    def self.is_item?(item)
      item_name = item.titlecase
      is_item = Global.read_config("magic-items", item_name)
    end

    def self.find_item (char, item)
      char.magic_items.select { |a| a.name == item }.first
    end

  end
end
