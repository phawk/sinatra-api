Sequel.migration do
  up do
    create_table :client_applications do
      primary_key :id
      String :name, null: false
      String :client_id, null: false
      String :client_secret, null: false
      Boolean :in_house_app, null: false, default: false
      Integer :user_id, null: false
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index :user_id
      index :client_id
    end
  end

  down do
    drop_table :client_applications
  end
end