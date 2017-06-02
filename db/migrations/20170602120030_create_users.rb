Sequel.migration do
  up do
    create_table :users do
      primary_key :id
      String :username, size: 255
      String :email, null: false, size: 255
      String :password_digest, null: false, size: 255
      jsonb :info, null: false, default: Sequel.pg_jsonb({})
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index :email, unique: true
      index :username, unique: true
    end

    create_table :refresh_tokens do
      primary_key :id
      foreign_key :user_id, :users, null: false
      String :token, null: false, size: 64
      DateTime :revoked_at
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index :token, unique: true
    end
  end

  down do
    drop_table :refresh_tokens
    drop_table :users
  end
end
