Sequel.migration do
  up do
    create_table :users do
      primary_key :id
      String :name
      String :email, null: false
      String :password_digest, null: false
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index :email
    end
  end

  down do
    drop_table :users
  end
end