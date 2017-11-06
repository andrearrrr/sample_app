class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.string :name
      t.string :identifier
      t.string :position

      t.timestamps
    end
  end
end
