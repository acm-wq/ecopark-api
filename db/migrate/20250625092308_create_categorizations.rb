class CreateCategorizations < ActiveRecord::Migration[8.0]
  def change
    create_table :categorizations do |t|
      t.references :landmark, null: false, foreign_key: true
      t.references :sub_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
