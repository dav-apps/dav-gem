require 'date'

module Dav
	class ActiveUser
		attr_reader :time, :count_daily, :count_monthly, :count_yearly

		def initialize(attributes)
			@time = DateTime.parse(attributes["time"])
			@count_daily = attributes["count_daily"]
			@count_monthly = attributes["count_monthly"]
			@count_yearly = attributes["count_yearly"]
		end
	end
end