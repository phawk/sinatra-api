Sequel.migration do
  up do
    create_table :client_applications do
      primary_key :id
      foreign_key :user_id, :users, null: false

      String :name, null: false, size: 50
      String :client_id, null: false, size: 64
      String :client_secret, null: false, size: 64
      Boolean :in_house_app, null: false, default: false
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index :user_id
      index :client_id, unique: true
      unique :client_secret
    end
  end

  down do
    drop_table :client_applications
  end
end