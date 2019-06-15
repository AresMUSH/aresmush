module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler

      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end

      def handle

        Global.logger.debug "Update actor shortcut and property names."
        config = DatabaseMigrator.read_config_file("utils.yml")
        ['i', 'in', 'inv'].each do |sc|
          config['utils']['shortcuts'][sc] = "echo %% There's no inventory system here."
        end
        DatabaseMigrator.write_config_file("utils.yml", config)

        client.emit_success "Done!"
      end

    end
  end
end
