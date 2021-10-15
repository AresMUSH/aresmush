module AresMUSH
  module Compliments
    class CompGiveCmd

      #comp <name>=<text>
      include CommandHandler
      attr_accessor :comp, :scene_or_names, :scene_id, :scene, :target_names

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.scene_or_names = args.arg1
        self.comp = args.arg2
      end

      def required_args
        [ self.scene_or_names, self.comp ]
      end

      def handle
        targets = []
        if (self.scene_or_names.is_integer?)
          self.scene_id = self.scene_or_names.to_i
          self.scene = Scene[self.scene_id]
          if !self.scene
            client.emit_failure t('compliments.not_scene')
            return
          end
        else
          self.target_names = self.scene_or_names.split(" ").map { |n| InputFormatter.titlecase_arg(n) }
          self.target_names.each do |name|
            target = Character.named(name)
             if !target
               client.emit_failure t('compliments.invalid_name')
               return
             elsif target.name == enactor_name
               client.emit_failure t('compliments.cant_comp_self')
               return
             end
            targets << target
          end
        end


        date = Time.now.strftime("%Y-%m-%d")
        luck_amount = Global.read_config("compliments", "luck_amount")
        give_luck = Global.read_config("compliments", "give_luck")
        comp_scenes = Global.read_config("compliments", "comp_scenes")
        if self.scene_id
          if comp_scenes
            self.target_names = []
            self.scene.participants.each do |target|
              if target == enactor

              else
                Comps.create(character: target, comp_msg: self.comp, from: enactor.name)
                if give_luck
                  FS3Skills.modify_luck(target, luck_amount)
                end
                message = t('compliments.has_left_comp', :from => enactor.name)
                Login.emit_if_logged_in target, message
                self.target_names << target.name
              end
            end
            client.emit_success t('compliments.left_comp', :name =>  self.target_names.join(", "))
          else
            client.emit_failure t('compliments.comp_scenes_not_enabled')
          end
        else
          targets.each do |target|
            Comps.create(character: target, comp_msg: self.comp, from: enactor.name)
            if give_luck
              FS3Skills.modify_luck(target, luck_amount)
            end
            message = t('compliments.has_left_comp', :from => enactor.name)
            Login.emit_if_logged_in target, message
          end
          client.emit_success t('compliments.left_comp', :name =>  self.target_names.join(", "))
        end
        Compliments.handle_comps_given_achievement(enactor)
      end

    end
  end
end
