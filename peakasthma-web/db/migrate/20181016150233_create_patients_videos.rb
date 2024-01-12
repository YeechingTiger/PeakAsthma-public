class CreatePatientsVideos < ActiveRecord::Migration[5.1]
  def change
    create_table :patients_videos, id: false do |t|
      t.references :patient
      t.references :video
      t.timestamps
    end
  end
end
