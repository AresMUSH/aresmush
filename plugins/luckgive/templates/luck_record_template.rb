module AresMUSH
  module LuckGive
    class LuckRecordTemplate < ErbTemplateRenderer
      attr_accessor :char, :paginator

      def initialize(char, paginator)
         @char = char
         @paginator = paginator
         super File.dirname(__FILE__) + "/luck_record.erb"
      end

      def luck_record
        @char.luck_record.to_a.sort_by { |s| s.date }
      end

      def luck
        @char.luck.floor
      end

    end
  end
end
