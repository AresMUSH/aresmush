module AresMUSH
  module FS3Combat
    class GearTemplate < AsyncTemplateRenderer

      include TemplateFormatters

      def initialize(list, title, client)
        @list = list
        @title = title
        super client
      end
      
      def build
        display_list = @list.sort.map { |k, v| type_display(k, v) }
        BorderedDisplay.list display_list, @title
      end
      
      def type_display(name, info)
        text = left(name.titleize, 20)
        text << display_field(info, "description", 58)
        text
      end
      
      def display_field(info, value_name, width)
        value = info[value_name] || "---"
        "#{left(value, width)}"
      end
    end
  end
end