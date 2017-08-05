module AresMUSH

  module FS3Skills
    class QualCmd
      include CommandHandler
      
      attr_accessor :name, :skill

      def parse_args
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)          
          self.name = trim_arg(args.arg1)
          self.skill = titlecase_arg(args.arg2)
      end
      
      def required_args
        {
          args: [ self.name, self.skill ],
          help: 'roll'
        }
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          a1 = score_attempt(model)
          a2 = score_attempt(model)
          a3 = score_attempt(model)
          
          
          final = [ a1[:score], a2[:score], a3[:score] ].sort
          final.shift
          
          total = final[0] + final[1]

          if (total >= 190)
            badge = "%xrMaster%xn"
          elsif (total >= 160)
            badge = "%xyExpert%xn"
          elsif (total >= 100)
            badge = "%xgBasic%xn"
          else
            badge = "None"
          end
          message = "Qualification Results - #{model.name} - #{self.skill}: \n\nAttempt 1: #{a1[:results]}\nAttempt 2: #{a2[:results]} \nAttempt 3: #{a3[:results]}\n\nFinal Score: #{total}\n\nBadge: #{badge}"
          template = BorderedDisplayTemplate.new message, nil, "%R%ld%RNote: Only qualifications run by staff count for awards."
          enactor_room.emit template.render
        end
      end
      
      def score_attempt(char)
        base = FS3Skills.ability_rating(char, self.skill) * 10
        r1 = FS3Skills.one_shot_roll(client, char, FS3Skills::RollParams.new(self.skill))
        r2 = FS3Skills.one_shot_roll(client, char, FS3Skills::RollParams.new(self.skill))
        r3 = FS3Skills.one_shot_roll(client, char, FS3Skills::RollParams.new(self.skill))
        
        score = base + roll_points(r1) + roll_points(r2) + roll_points(r3)
        score = [ 100, score ].min
        
        { 
          :score => score,
          :results => "#{score} - #{r1[:success_title]}, #{r2[:success_title]}, #{r3[:success_title]}"
        }
      end
      
      def roll_points(roll)
        successes = roll[:successes]
        
        case successes
        when -1
          -10
        when 0
          0
        when 1, 2
          5
        when 3, 4
          10
        when 5, 6
          15
        when 7..99
          20
        else
          raise "Unexpected roll result: #{successes}"
        end
      end
    end
  end
end
