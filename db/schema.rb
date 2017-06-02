Sequel.migration do
  change do
    create_table(:schema_migrations) do
      String :filename, :text=>true, :null=>false
      
      primary_key [:filename]
    end
    
    create_table(:users, :ignore_index_errors=>true) do
      primary_key :id
      String :username, :size=>255
      String :email, :size=>255, :null=>false
      String :password_digest, :size=>255, :null=>false
      String :info, :null=>false
      DateTime :created_at, :null=>false
      DateTime :updated_at, :null=>false
      
      index [:email], :unique=>true
      index [:username], :unique=>true
    end
    
    create_table(:refresh_tokens, :ignore_index_errors=>true) do
      primary_key :id
      foreign_key :user_id, :users, :null=>false, :key=>[:id]
      String :token, :size=>64, :null=>false
      DateTime :revoked_at
      DateTime :created_at, :null=>false
      DateTime :updated_at, :null=>false
      
      index [:token], :unique=>true
    end
  end
end
