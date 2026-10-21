class CreatePerformances < ActiveRecord::Migration[7.1]
  def change
    create_table :performances do |t|
      t.datetime :starts_at
      t.references :stage, foreign_key: true
      t.references :artist, foreign_key: true
      t.timestamps
    end
  end
end
