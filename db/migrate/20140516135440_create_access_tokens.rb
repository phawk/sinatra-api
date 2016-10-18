class CreateAccessTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :access_tokens do |t|
      t.string :token, null: false
      t.references :client_application, null: false
      t.references :user, null: false

      t.timestamps null: false
    end

    add_index :access_tokens, :token, unique: true
  end
end
