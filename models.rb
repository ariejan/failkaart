DB = ENV['RACK_ENV'] == "test" ? Sequel.sqlite(":memory:") : Sequel.sqlite("failkaart.db")

unless DB.table_exists?(:users)
	DB.create_table :users do
		primary_key :id
		string :ip
	end
end

unless DB.table_exists?(:fails)
	DB.create_table :fails do
		primary_key :id
		integer :user_id
		string :text
		datetime :created_at
		integer :votes_count
	end
end

unless DB.table_exists?(:fails_users)
	DB.create_table :fails_users do
		integer :user_id
		integer :fail_id
	end
end

class User < Sequel::Model
  many_to_many :fails
end

class Fail < Sequel::Model
  many_to_many :users
end

class FailsUser < Sequel::Model
  many_to_one :user
  many_to_one :fail
end