module Dav
	class EventSummary
		attr_reader :id, :time, :total, :properties
		attr_accessor :event_id, :period

		def initialize(attributes)
			@id = attributes["id"]
			@event_id = attributes["event_id"]
			@period = attributes["period"]
			@time = attributes["time"]
			@total = attributes["total"]
			@properties = attributes["properties"]
		end
	end
end