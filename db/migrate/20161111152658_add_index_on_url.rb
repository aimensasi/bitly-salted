class AddIndexOnUrl < ActiveRecord::Migration
	
	def up
		add_index :urls, :url	
	end

	def down
		remove_index :urls, :url
	end
end
