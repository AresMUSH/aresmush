module AresMUSH  

  module Migrations
    class MigrationBeta65Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Remove tos config option."
        config = DatabaseMigrator.read_config_file("login.yml")
        config['login'].delete 'use_terms_of_service'
        DatabaseMigrator.write_config_file("login.yml", config)


        Global.logger.debug "Adding demographics."
        config = DatabaseMigrator.read_config_file("demographics.yml")
        genders = {
          'Male' => {
            'possessive_pronoun' => 'his',
            'subjective_pronoun' => 'he',
            'objective_pronoun' => 'him',
            'noun' => 'man'
           },
           'Female' => {
            'possessive_pronoun' => 'her',
            'subjective_pronoun' => 'she',
            'objective_pronoun' => 'her',
            'noun' => 'woman'
          },
          'Other' => {
            'possessive_pronoun' => 'their',
            'subjective_pronoun' => 'they',
            'objective_pronoun' => 'them',
            'noun' => 'person'
          }
        }
        config['demographics']['genders'] = genders
        DatabaseMigrator.write_config_file("demographics.yml", config)
      end 
    end
  end
end