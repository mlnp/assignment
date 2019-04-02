class AddStatsToUrl < ActiveRecord::Migration[5.2]
  def change
    add_column :urls, :last_usage, :datetime
    add_column :urls, :usage_count, :integer, default: 0
  end
end
