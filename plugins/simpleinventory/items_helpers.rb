module AresMUSH
  module Simpleinventory

    def self.is_item?(item)
      item_name = item.titlecase
      is_item = Global.read_config("items", item_name)
    end

    def self.item_desc(item)
      Global.read_config("items", item, "desc")
    end

    def self.get_items(char)
      list = char.items || []
      list.map { |i|
        {
          name: i,
          desc:  Website.format_markdown_for_html(Simpleinventory.item_desc(i))
        }}
    end

  end
end
