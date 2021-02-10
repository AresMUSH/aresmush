module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler

      attr_accessor :role


      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end

      def parse_args
        self.role = titlecase_arg(cmd.args)
      end


      def handle

        Creature.all.each do |p|
          # client.emit p.major_school
          client.emit "#{p.name}- #{ p.major_school['name']}"

          # p.update(primary_school: "#{p.primary_school['name']}")
          # client.emit "DONE: #{p.primary_school}"
        end
      end



    end
  end
end
