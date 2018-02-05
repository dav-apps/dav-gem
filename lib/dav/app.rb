module Dav
   class App
      attr_reader :name, :description, :published, :id, :link_web, :link_play, :link_windows, :used_storage, :tables, :events
      
      def initialize(attributes)
         @id = attributes["id"]
         @name = attributes["name"]
         @description = attributes["description"]
         @published = attributes["published"]
         @link_web = attributes["link_web"]
         @link_play = attributes["link_play"]
         @link_windows = attributes["link_windows"]
         @used_storage = attributes["used_storage"]
         @tables = convert_json_to_tables_array(attributes["tables"]) if attributes["tables"]
         @events = convert_json_to_events_array(attributes["events"]) if attributes["events"]
      end
      
      def self.create(jwt, name, desc)
         url = $api_url + 'apps/app?name=' + name + '&desc=' + desc
         result = send_http_request(url, "POST", {"Authorization" => jwt}, nil)
         if result["code"] == 201
            app = App.new(JSON.parse result["body"])
         else
            raise_error(JSON.parse result["body"])
         end
      end
      
      def self.get(jwt, id)
         url = $api_url + "apps/app/#{id}"
         result = send_http_request(url, "GET", {"Authorization" => jwt}, nil)
         if result["code"] == 200
            app = App.new(JSON.parse result["body"])
         else
            raise_error(JSON.parse result["body"])
         end
      end

      def self.get_all_apps(auth)
         url = $api_url + "apps/apps/all"
         result = send_http_request(url, "GET", {"Authorization" => create_auth_token(auth)}, nil)
         if(result["code"] == 200)
            apps_json = (JSON.parse(result["body"]).to_a)[0][1].to_a
            apps_array = convert_json_to_apps_array(apps_json)
         else
            raise_error(JSON.parse result["body"])
         end
      end
      
      def update(jwt, properties)
         url = $api_url + "apps/app/#{@id}"
         result = send_http_request(url, "PUT", {"Authorization" => jwt, "Content-Type" => "application/json"}, properties)
         if result["code"] == 200
            body = JSON.parse(result["body"])
            @name = body["name"]
            @description = body["description"]
            @link_web = body["link_web"]
            @link_play = body["link_play"]
            @link_windows = body["link_windows"]
         else
            raise_error(JSON.parse result["body"])
         end
      end
      
      def delete(jwt)
         url = $api_url + "apps/app/#{@id}"
         result = send_http_request(url, "DELETE", {"Authorization" => jwt}, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse result["body"])
         end
      end
      
      def log_event(auth, name)
         url = $api_url + "analytics/event?name=#{name}&app_id=#{@id}"
         result = send_http_request(url, "POST", {"Authorization" => create_auth_token(auth)}, nil)
         if result["code"] == 201
            event = Event.new(JSON.parse result["body"])
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
   end
end