module AresMUSH
  module Custom
    class SpellDetailCmd
      include CommandHandler
      attr_accessor :name

      def parse_args
        self.name = titlecase_arg(cmd.args)
      end

      def required_args
        [ self.name ]
      end

      def check_spell_exists
        return t('custom.not_spell') if !Custom.is_spell?(self.name)
        return nil
      end


      def handle
           template = SpellDetailTemplate.new(name)
           client.emit template.render
      end

    end
  end
end
