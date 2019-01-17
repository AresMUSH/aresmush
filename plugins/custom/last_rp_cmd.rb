module AresMUSH
  module Custom
    class LastRPCmd
    # lastrp
      include CommandHandler

      # attr_accessor :plot_name, :plot_form
      #
      # def parse_args
      #   args = cmd.parse_args(ArgParser.arg1_equals_arg2)
      #   self.plot_name = trim_arg(args.arg1)
      #   self.plot_form = trim_arg(args.arg2)
      # end

      def handle
        client.emit "Last RP Scenes for All Characters"
        chars = Chargen.approved_chars
        chars.each do |c|
          char_name = c.name
          last_scene = Character.find_one_by_name(char_name).scenes_starring.sort_by { |s| s.date_shared }[1]
          client.emit "#{char_name}: #{last_scene.date_shared}"
        end
      end

    end
  end
end
