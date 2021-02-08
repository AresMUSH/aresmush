module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler

      attr_accessor :role


      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end



      # def parse_args
      #   self.role = titlecase_arg(cmd.args)
      # end
      #
      #
      # def handle
      #   client.emit self.role.upcase
      #   client.emit "___________________________________"
      #   chars = Chargen.approved_chars.select { |c| c.has_role?(role) }
      #
      #   chars.each do |c|
      #     client.emit c.name
      #   end
      #
      #
      # end

      def handle
        chars = Character.all.select {|c| c.scenes_starring.count == 0};
        chars = chars.select {|c| c.idle_state == "Gone"}
        chars.each do |c|
          client.emit "#{c.name} - #{c.scenes_starring.count} scenes - #{c.idle_state}"
        end
      end

    end
  end
end
