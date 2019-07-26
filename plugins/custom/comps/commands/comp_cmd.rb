module AresMUSH
  module Custom
    class CompGiveCmd
      #comp <name>=<text>
      include CommandHandler
      attr_accessor :targets, :comp, :target_names

      def parse_args
       args = cmd.parse_args(ArgParser.arg1_equals_arg2)
       self.target_names = args.arg1.split(" ").map { |n| InputFormatter.titlecase_arg(n) }

       self.targets = []
        self.target_names.each do |name|
         target = Character.named(name)
         return  t('custom.invalid_name') if !target
         self.targets << target
       end
       #
       # self.target = Character.named(args.arg1)
       self.comp = args.arg2
      end

      def handle
        date = Time.now.strftime("%Y-%m-%d")
        targets.each do |target|
          Comps.create(date: date, character: target, comp_msg: self.comp, from: enactor.name)
          FS3Skills.modify_luck(target, 0.05)
          message = t('custom.has_left_comp', :from => enactor.name)
          Login.emit_if_logged_in target, message
        end

        client.emit_success t('custom.left_comp', :name =>  self.target_names.join(", "))



      end

    end
  end
end
