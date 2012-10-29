Sequel.migration do
  transaction
  change do
    create_table(:dbrefs) do
      primary_key :id
      String :type
      boolean :is_deleted
    end

    create_table(:players) do
      String :name
      String :password
      foreign_key :dbref_id, :dbrefs, :null=>false
      primary_key [:dbref_id]
      index [:dbref_id]
    end
  end
end
