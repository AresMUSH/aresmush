module AresMUSH

  module Describe
    class Desc
      include AresMUSH::Plugin

      def want_command?(cmd)
        cmd.root_is?("desc")
      end

      def on_command(client, cmd)
        args = cmd.crack_args!(/(?<target>[^\=]+)\=(?<desc>.+)/)

        if args.nil?
          client.emit_failure(t('describe.invalid_desc_syntax'))
          return
        end

        target = args[:target]
        desc = args[:desc]

        model = Rooms.find_visible_object(target, client) 
        return if (model.nil?)
        
        Describe.set_desc(model, desc)
        client.emit_success(t('describe.desc_set', :name => model["name"]))
      end
    end
  end
end
