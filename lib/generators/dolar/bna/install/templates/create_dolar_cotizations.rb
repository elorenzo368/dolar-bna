class CreateDolarCotizations < ActiveRecord::Migration[5.2]
  def change
    create_table :dolar_cotizations do |t|
      t.date :date
      t.string :dolar_type
      t.float :dolar_buy
      t.float :dolar_sell

      t.timestamps
    end
  end
end
