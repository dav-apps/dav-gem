module Dav
   class Event
      attr_reader :name, :id
      
      def initialize(attributes)
         @name = attributes["name"]
         @id = attributes["id"]
      end
      
      def self.log(auth, app_id, name)
         url = $api_url + 'analytics/event?name=' + name + '&app_id=' + app_id.to_s
         result = send_http_request(url, "POST", {"Authorization" => create_auth_token(auth)}, nil)
         if result["code"] == 201
            event = Event.new(JSON.parse(result["body"]))
         else
            raise_error(JSON.parse result["body"])
         end
      end
   end
end