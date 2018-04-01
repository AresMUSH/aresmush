module AresMUSH
  module Manage
    class DatabaseMigrator
      def migrate(client)
        path = File.join(AresMUSH.root_path, "install", "migrations")
        migrations = Dir["#{path}/*.rb"].sort
        applied_migrations = Game.master.applied_migrations || []
      
        migrations.each do |file|
          migration_name = File.basename(file, ".rb")
          if applied_migrations.include?(migration_name)
            Global.logger.info "Migration #{migration_name} already applied."
            client.emit_ooc t('manage.migration_already_applied', :name => migration_name)
            next
          end
        
          Global.logger.info "Applying migration #{migration_name}"
          client.emit_ooc t('manage.applying_migration', :name => migration_name)
        
          load file
          migrator_class = find_migrator_class(migration_name)
          migrator = migrator_class.new
          migrator.migrate(client)

          applied_migrations << migration_name
        
          Global.logger.info "Migration #{migration_name} applied."
          client.emit_ooc t('manage.migration_applied', :name => migration_name)
        end

        Game.master.update(applied_migrations: applied_migrations)
      end
      
      def find_migrator_class(migration_name)
        search = migration_name.after("_")
        class_name = AresMUSH::Migrations.constants.select { |c| c.upcase == search.to_sym.upcase }.first
        if (!class_name)
          raise "Migration #{migration_name} appears to be misnamed.  The migrator class can't be found."
        end
        
        Object.const_get("AresMUSH::Migrations::#{class_name}")
      end
    end
  end
end