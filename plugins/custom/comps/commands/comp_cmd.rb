module AresMUSH
  module Custom
    class CompGiveCmd
      #comp <name>=<text>
      include CommandHandler
      attr_accessor :targets, :comp, :target_names, :scene_id, :scene

      def parse_args
       args = cmd.parse_args(ArgParser.arg1_equals_arg2)

       if args.arg1.is_integer?
         self.scene_id = args.arg1

       else
        self.target_names = args.arg1.split(" ").map { |n| InputFormatter.titlecase_arg(n) }
        self.targets = []
         self.target_names.each do |name|
          target = Character.named(name)
          return  t('custom.invalid_name') if !target
          self.targets << target
        end
       end


       #
       # self.target = Character.named(args.arg1)
       self.comp = args.arg2
      end

      def check_errors
        self.scene = Scene[scene_id]
        return "That is not a scene number." if (self.scene_id && !scene)
      end

      def handle
        date = Time.now.strftime("%Y-%m-%d")
        if self.scene_id
          self.target_names = []
          self.scene.participants.each do |target|
            if target == enactor

            else
              Comps.create(date: date, character: target, comp_msg: self.comp, from: enactor.name)
              FS3Skills.modify_luck(target, 0.05)
              message = t('custom.has_left_comp', :from => enactor.name)
              Login.emit_if_logged_in target, message
              self.target_names << target.name
            end
          end
          client.emit_success t('custom.left_comp', :name =>  self.target_names.join(", "))
        else
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
end
