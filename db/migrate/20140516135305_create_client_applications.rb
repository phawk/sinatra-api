class CreateClientApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :client_applications do |t|
      t.string :name, null: false
      t.string :client_id, null: false
      t.string :client_secret, null: false
      t.boolean :in_house_app, null: false, default: false
      t.references :user, null: false

      t.timestamps null: false
    end

    add_index :client_applications, :client_id
  end
end
