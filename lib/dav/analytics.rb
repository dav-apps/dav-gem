module Dav
   class Event
      attr_reader :id, :name, :logs
      
      def initialize(attributes)
         @id = attributes["id"]
         @name = attributes["name"]
         @logs = attributes["logs"]
      end
      
      def self.log(auth, app_id, name)
         url = $api_url + "analytics/event?name=#{name}&app_id=#{app_id}"
         result = send_http_request(url, "POST", {"Authorization" => create_auth_token(auth)}, nil)
         if result["code"] == 201
            event = Event.new(JSON.parse(result["body"]))
         else
            raise_error(JSON.parse(result["body"]))
         end
      end

      def self.get(jwt, id, app_id)
         url = $api_url + "analytics/event/#{id}?app_id=#{app_id}"
         result = send_http_request(url, "GET", {"Authorization" => jwt}, nil)

         if result["code"] == 200
            event = Event.new(JSON.parse(result["body"]))
         else
            raise_error(JSON.parse(result["body"]))
         end
      end

      def self.get_by_name(jwt, name, app_id)
         url = $api_url + "analytics/event?name=#{name}&app_id=#{app_id}"
         result = send_http_request(url, "GET", {"Authorization" => jwt}, nil)

         if result["code"] == 200
            event = Event.new(JSON.parse(result["body"]))
         else
            raise_error(JSON.parse(result["body"]))
         end
      end

      def update(jwt, name)
         url = $api_url + "analytics/event/#{@id}"
         result = send_http_request(url, "PUT", {"Authorization" => jwt, "Content-Type" => "application/json"}, {name: name})

         if result["code"] == 200
            @name = name
            return self
         else
            raise_error(JSON.parse(result["body"]))
         end
      end

      def delete(jwt)
         url = $api_url + "analytics/event/#{@id}"
         result = send_http_request(url, "DELETE", {"Authorization" => jwt}, nil)

         if result["code"] == 200
            return true
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
   end
end