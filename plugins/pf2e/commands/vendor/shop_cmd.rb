module AresMUSH
  module Pf2e
    class ShopCmd
      include CommandHandler

      attr_accessor :vendor_slug

      def parse_args
        self.vendor_slug = cmd.args ? cmd.args.strip.downcase : nil
      end

      def handle
        if self.vendor_slug.blank?
          client.emit Pf2e.format_vendor_list
        else
          text = Pf2e.format_vendor_stock(self.vendor_slug)
          client.emit text
        end
      end
    end
  end
end
