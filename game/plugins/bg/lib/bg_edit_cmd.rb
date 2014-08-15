module AresMUSH
  module Bg
    class BgEditCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :target

      def want_command?(client, cmd)
        cmd.root_is?("bg") && cmd.switch_is?("edit")
      end
            
      def crack!
        if (cmd.args.nil?)
          self.target = client.name
        else
          self.target = trim_input(cmd.args)
        end
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client) do |model|
          if (!Bg.can_edit(client.char, model, client))
            return
          end
          
          if (self.target == client.name)
            client.grab "bg/set #{model.background}"
          else
            client.grab "bg/set #{target}=#{model.background}"
          end
        end
      end
    end
  end
end