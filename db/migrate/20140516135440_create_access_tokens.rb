class CreateAccessTokens < ActiveRecord::Migration
  def change
    create_table :access_tokens do |t|
      t.string :token
      t.integer :client_application_id
      t.integer :user_id

      t.timestamps
    end

    add_index :access_tokens, :token
    add_index :access_tokens, :user_id
  end
end
