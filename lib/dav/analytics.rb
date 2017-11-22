module Dav
   class Event
      attr_accessor :name, :id
      
      def initialize(attributes)
         @name = attributes["name"]
         @id = attributes["id"]
      end
      
      def self.log(auth, app_id, name)
         create_event_url = Dav::API_URL + 'analytics/event?name=' + name + '&app_id=' + app_id.to_s
         json = send_http_request(create_event_url, "POST", {"Authorization" => create_auth_token(auth)}, nil)
         event = Event.new(json)
      end
   end
end