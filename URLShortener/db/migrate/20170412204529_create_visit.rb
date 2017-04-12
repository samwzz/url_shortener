class CreateVisit < ActiveRecord::Migration[5.0]
  def change
    create_table :visits do |t|
      t.integer :user_id
      t.integer :shortened_url_id
      t.timestamp
    end

  add_index(:visits, :user_id)
  add_index(:visits, :shortened_url_id)
  end
end
