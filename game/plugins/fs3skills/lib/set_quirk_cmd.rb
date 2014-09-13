module AresMUSH

  module FS3Skills
    class SetQuirkCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name, :add_quirk

      def initialize
        self.required_args = ['name']
        self.help_topic = 'skills'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("quirk") && (cmd.switch_is?("add") || cmd.switch_is?("remove"))
      end

      def crack!
        self.name = titleize_input(cmd.args)
        self.add_quirk = cmd.switch_is?("add")
      end
      
      def check_approval
        return t('fs3skills.cant_be_changed') if client.char.is_approved?
        return nil
      end
            
      def handle
        if (self.add_quirk)
          if (client.char.fs3_quirks.include?(self.name))
            client.emit_failure t('fs3skills.quirk_already_selected')
            return
          end
          
          client.char.fs3_quirks << self.name
          client.char.save
          client.emit_success t('fs3skills.quirk_selected', :name => self.name)
        else
          if (!client.char.fs3_quirks.include?(self.name))
            client.emit_failure t('fs3skills.quirk_not_selected')
            return
          end
          
          client.char.fs3_quirks.delete self.name
          client.char.save
          client.emit_success t('fs3skills.quirk_removed', :name => self.name)
        end
      end
    end
  end
end
