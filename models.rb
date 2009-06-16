DB = Sequel.sqlite("fixedintm2.db")

unless DB.table_exists?(:users)
	DB.create_table :users do
		primary_key :id
		string :ip
	end
end

unless DB.table_exists?(:fixes)
	DB.create_table :fixes do
		primary_key :id
		integer :user_id
		string :text
		datetime :created_at
		integer :votes_count
	end
end

unless DB.table_exists?(:fixes_users)
	DB.create_table :fixes_users do
		integer :user_id
		integer :fix_id
	end
end

class User < Sequel::Model
  many_to_many :fixes
end

class Fix < Sequel::Model
  many_to_many :users
end

class FixesUser < Sequel::Model
  many_to_one :user
  many_to_one :fix
end