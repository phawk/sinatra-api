class CreateClientApplications < ActiveRecord::Migration
  def change
    create_table :client_applications do |t|
      t.string :name
      t.string :client_id
      t.string :client_secret
      t.integer :user_id

      t.timestamps
    end

    add_index :client_applications, :client_id
    add_index :client_applications, :user_id
  end
end
