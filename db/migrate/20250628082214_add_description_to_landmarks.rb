class AddDescriptionToLandmarks < ActiveRecord::Migration[8.0]
  def change
    add_column :landmarks, :description, :text,
      null: false,
      default: ""
  end
end
