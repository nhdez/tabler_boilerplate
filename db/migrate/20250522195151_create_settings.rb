class CreateSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :settings do |t|
      t.string :name, null: false
      t.text :value
      t.text :description
      t.string :input_type, default: 'text'

      t.timestamps
    end
    
    add_index :settings, :name, unique: true
  end
end
