Sequel.migration do
  change do
    create_table(:schema_migrations) do
      String :filename, :text=>true, :null=>false
      
      primary_key [:filename]
    end
    
    create_table(:users, :ignore_index_errors=>true) do
      primary_key :id
      String :name, :size=>50
      String :email, :size=>255, :null=>false
      String :password_digest, :size=>255, :null=>false
      DateTime :created_at, :null=>false
      DateTime :updated_at, :null=>false
      
      index [:email], :unique=>true
    end
    
    create_table(:access_tokens, :ignore_index_errors=>true) do
      primary_key :id
      foreign_key :user_id, :users, :null=>false, :key=>[:id]
      String :token, :size=>64, :null=>false
      Integer :client_application_id, :null=>false
      DateTime :created_at, :null=>false
      DateTime :updated_at, :null=>false
      
      index [:client_application_id]
      index [:token], :unique=>true
      index [:user_id]
    end
    
    create_table(:client_applications, :ignore_index_errors=>true) do
      primary_key :id
      foreign_key :user_id, :users, :null=>false, :key=>[:id]
      String :name, :size=>50, :null=>false
      String :client_id, :size=>64, :null=>false
      String :client_secret, :size=>64, :null=>false
      TrueClass :in_house_app, :default=>false, :null=>false
      DateTime :created_at, :null=>false
      DateTime :updated_at, :null=>false
      
      index [:client_id], :unique=>true
      index [:client_secret], :name=>:client_applications_client_secret_key, :unique=>true
      index [:user_id]
    end
  end
end
