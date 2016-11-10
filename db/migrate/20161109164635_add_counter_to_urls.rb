class AddCounterToUrls < ActiveRecord::Migration
	def up
		add_column :urls, :counter, :integer, :default => 0
	end

	def down
		remove_column :urls, :counter
	end
end
