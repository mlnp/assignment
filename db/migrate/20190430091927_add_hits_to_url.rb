class AddHitsToUrl < ActiveRecord::Migration[5.2]
  def change
  	add_column :urls, :hits, :integer, default: 0
  end
end
