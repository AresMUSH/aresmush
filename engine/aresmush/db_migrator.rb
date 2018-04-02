module AresMUSH
  class DatabaseMigrator
    def migrate
      path = File.join(AresMUSH.root_path, "install", "migrations")
      migrations = Dir["#{path}/*.rb"].sort
      applied_migrations_path = File.join(path, 'applied.txt')
      
      if (File.exist?(applied_migrations_path))
        applied_migrations = File.readlines(applied_migrations_path).map { |l| l.chomp }
      else
        applied_migrations = []
      end
      
      migrations.each do |file|
        migration_name = File.basename(file, ".rb")
        if applied_migrations.include?(migration_name)
          puts "Migration #{migration_name} already applied."
          next
        end
        
        puts "Applying migration #{migration_name}"
        
        load file
        
        migrator_class = find_migrator_class(migration_name)
        migrator = migrator_class.new
        migrator.migrate

        applied_migrations << migration_name
        
        puts "Migration #{migration_name} applied."
      end

      File.open(applied_migrations_path, 'w') do |file|
        file.write applied_migrations.join("\n")
      end
      
      puts "Migrations complete.  You can now restart the game using `bin/startares`."
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