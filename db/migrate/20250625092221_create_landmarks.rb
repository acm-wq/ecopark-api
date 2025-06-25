class CreateLandmarks < ActiveRecord::Migration[8.0]
  def change
    create_table :landmarks do |t|
      t.string :name

      t.timestamps
    end
  end
end
