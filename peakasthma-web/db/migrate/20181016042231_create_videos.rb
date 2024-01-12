class CreateVideos < ActiveRecord::Migration[5.1]
  def change
    create_table :videos do |t|
      t.string :video_name
      t.string :url
      t.integer :week
      t.integer :day
      t.timestamps
    end
  end
end
