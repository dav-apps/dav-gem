module Dav
   class EventLog
      attr_reader :id, :created_at, :properties
      attr_accessor :event_id

      def initialize(attributes)
         @id = attributes["id"]
         @event_id = attributes["event_id"]
         @created_at = attributes["created_at"]
         @properties = attributes["properties"]
      end
   end
end