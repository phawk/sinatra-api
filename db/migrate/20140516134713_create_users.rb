class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, null: false
      t.string :password_digest, null: false

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
