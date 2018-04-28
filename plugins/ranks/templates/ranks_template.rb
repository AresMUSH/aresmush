module AresMUSH
  module Ranks
    class RanksTemplate < ErbTemplateRenderer
      
      attr_accessor :config, :name
      
      def initialize(config, name)
        @config = config
        @name = name
        
        # There are two built-in rank templates - a generic one and one that shows 
        # officer/enlisted ranks side by side
        if (Global.read_config("ranks", "rank_style") == "military")
          template_file = "/military_ranks.erb"
        else
          template_file = "/ranks.erb"
        end
        
        super File.dirname(__FILE__) + template_file
      end
      
      def officer_ranks
        config["Officer"].to_a
      end
      
      def enlisted_ranks
        config["Enlisted"].to_a
      end
      
      def rank(ranks_list, level)
        rank = ranks_list[level]
        return "" if !rank
        name = rank[0]
        allowed = rank[1]
        allowed ? name : "%xx%xh#{name}%xn"
      end
      
      def rank_rows
        [ officer_ranks.count, enlisted_ranks.count ].max
      end
    end
  end
end