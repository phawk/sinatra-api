Sequel.migration do
  up do
    create_table :users do
      primary_key :id
      String :name, size: 50
      String :email, null: false, size: 255
      String :password_digest, null: false, size: 255
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index :email, unique: true
    end
  end

  down do
    drop_table :users
  end
end