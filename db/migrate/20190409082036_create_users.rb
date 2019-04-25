class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, null: false
      t.string :password_digest, null: false
      t.datetime :last_login

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
