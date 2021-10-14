module AresMUSH
  module Compliments
    class CompsTemplate < ErbTemplateRenderer
      attr_accessor :char, :paginator

      def initialize(char, paginator)
         @char = char
         @paginator = paginator
         super File.dirname(__FILE__) + "/comps.erb"
      end

      def date(c)
        OOCTime.format_date_for_entry(c.created_at)
      end

    end
  end
end
