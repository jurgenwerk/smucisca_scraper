class CreateSkiData < ActiveRecord::Migration
  def change
    create_table :ski_data do |t|
      t.json :data

      t.timestamps
    end
  end
end
