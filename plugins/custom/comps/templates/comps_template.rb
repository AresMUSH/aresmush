module AresMUSH
  module Custom
    class CompsTemplate < ErbTemplateRenderer
      attr_accessor :char, :paginator

      def initialize(char, paginator)
         @char = char
         @paginator = paginator
         super File.dirname(__FILE__) + "/comps.erb"
      end

      # def initialize(char)
      #   @char = char
      #   super File.dirname(__FILE__) + "/comps.erb"
      # end

      def comps_recieved
        @char.comps.to_a
      end

      def comps_list
        self.comps_recieved.sort_by { |s| s.date }
      end

    end
  end
end
