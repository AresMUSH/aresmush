module AresMUSH
  module Manage
    class BlocksTemplate < ErbTemplateRenderer
      
      attr_accessor :enactor
      
      def initialize(enactor)
        @enactor = enactor
        super File.dirname(__FILE__) + '/blocks.erb'
      end
      
      def blocks
        @enactor.blocks.to_a.sort_by { |b| [ b.blocked.name, b.block_type ] }
      end
      
      def block_types
        Manage.block_types
      end
    end
  end
end