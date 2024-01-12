class CreateTips < ActiveRecord::Migration[5.1]
  def change
    create_table :tips do |t|
      t.string :tip

      t.timestamps
    end
  end
end
