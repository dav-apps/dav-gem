module Dav
   class Dev
      attr_reader :id, :api_key, :secret_key, :user_id, :uuid, :apps
      
      def initialize(attributes)
         @id = attributes["id"]
         @api_key = attributes["api_key"]
         @secret_key = attributes["secret_key"]
         @user_id = attributes["user_id"]
         @uuid = attributes["uuid"]
         @apps = convert_json_to_apps_array(attributes["apps"]) if attributes["apps"]
      end
      
      def self.create(jwt)
         url = $api_url + "devs/dev"
         result = send_http_request(url, "POST", {"Authorization" => jwt}, nil)
         if result["code"] == 201
            Dev.new(JSON.parse(result["body"]))
         else
            raise_error(result["body"])
         end
      end
      
      def self.get(jwt)
         url = $api_url + "devs/dev"
         result = send_http_request(url, "GET", {"Authorization" => jwt}, nil)
         if result["code"] == 200
            Dev.new(JSON.parse(result["body"]))
         else
            raise_error(result["body"])
         end
      end
      
      def self.get_by_api_key(auth, api_key)
         url = $api_url + "devs/dev/#{api_key}"
         result = send_http_request(url, "GET", {"Authorization" => create_auth_token(auth)}, nil)
         if result["code"] == 200
            Dev.new(JSON.parse(result["body"]))
         else
            raise_error(result["body"])
         end
      end
      
      def delete(jwt)
         url = $api_url + "devs/dev"
         result = send_http_request(url, "DELETE", {"Authorization" => jwt}, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(result["body"])
         end
      end
      
      def generate_new_keys(jwt)
         url = $api_url + "devs"
         result = send_http_request(url, "POST", {"Authorization" => jwt}, nil)
         if result["code"] == 200
            @api_key = JSON.parse(result["body"])["api_key"]
            @secret_key = JSON.parse(result["body"])["secret_key"]
            @uuid = JSON.parse(result["body"])["uuid"]
         else
            raise_error(result["body"])
         end
      end
   end
end