module Dav
   class Event
      attr_accessor :name, :id
      
      def initialize(attributes)
         @name = attributes["name"]
         @id = attributes["id"]
      end
      
      def self.log(auth, app, name)
         create_event_url = Dav::API_URL + 'analytics/event?name=' + name + '&app_id=' + app.id.to_s
         json = send_http_request(create_event_url, create_auth_token(auth), "POST")
         event = Event.new(json)
      end
      
      #def self.get(auth, name)
      #   get_event_url = Dav::API_URL + 'analytics/event?name=' + name
      #   json = send_http_request(get_event_url, create_auth_token(auth), "GET")
      #end
   end
end