class CreateStages < ActiveRecord::Migration[7.1]
  def change
    create_table :stages do |t|
      t.string  :name
      t.integer :capacity
      t.references :festival, foreign_key: true
      t.timestamps
    end
  end
end
