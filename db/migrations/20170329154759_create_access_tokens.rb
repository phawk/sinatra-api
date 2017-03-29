Sequel.migration do
  up do
    create_table :access_tokens do
      primary_key :id
      foreign_key :user_id, :users, null: false

      String :token, null: false
      Integer :client_application_id, null: false
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index :client_application_id
      index :user_id
      index :token, unique: true
    end
  end

  down do
    drop_table :access_tokens
  end
end