module Dav
   $api_url = "http://localhost:3111/v1/"
   
   class Auth
      attr_reader :api_key, :secret_key, :uuid
      
      def initialize(api_key: "", secret_key: "", uuid: "", environment: "development")
         @api_key = api_key
         @secret_key = secret_key
         @uuid = uuid
         
         if environment == "production"
            $api_url = ENV["API_BASE_URL"]
         else
            $api_url = "http://localhost:3111/v1/"
         end
      end
      
      def login(email, password)
         # Send login request
         login_url = $api_url + "auth/login?email=#{email}&password=#{password}"
         login_result = send_http_request(login_url, "GET", {"Authorization" => create_auth_token(self)}, nil)
         if login_result["code"] == 200
            jwt = JSON.parse(login_result["body"])["jwt"]
            user_id = JSON.parse(login_result["body"])["user_id"]
            
            # Get the user details with the user id and create new User object
            get_user_url = "#{$api_url}auth/user/#{user_id}"
            get_result = send_http_request(get_user_url, "GET", {"Authorization" => jwt}, nil)
            if get_result["code"] == 200
               user = Dav::User.new(JSON.parse get_result["body"])
               user.jwt = jwt
               user.id = user_id
               user
            else
               raise_error(JSON.parse get_result["body"])
            end
         else
            raise_error(JSON.parse login_result["body"])
         end
      end

      def self.login_by_jwt(jwt, api_key)
         login_url = $api_url + "auth/login_by_jwt?api_key=#{api_key}"
         login_result = send_http_request(login_url, "GET", {"Authorization" => jwt}, nil)
         if login_result["code"] == 200
            jwt = JSON.parse(login_result["body"])["jwt"]
            user_id = JSON.parse(login_result["body"])["user_id"]
            
            # Get the user details with the user id and create new User object
            get_user_url = "#{$api_url}auth/user/#{user_id}"
            get_result = send_http_request(get_user_url, "GET", {"Authorization" => jwt}, nil)
            if get_result["code"] == 200
               user = Dav::User.new(JSON.parse get_result["body"])
               user.jwt = jwt
               user.id = user_id
               user
            else
               raise_error(JSON.parse get_result["body"])
            end
         else
            raise_error(JSON.parse login_result["body"])
         end
      end
      
      def signup(email, password, username)
         url = $api_url + "auth/signup?email=#{email}&password=#{password}&username=#{username}"
         result = send_http_request(url, "POST", {"Authorization" => create_auth_token(self)}, nil)
         if result["code"] == 201
            JSON.parse result["body"]
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
   end
end


def raise_error(json)
   error_message = ""
   i = 0
   json.values[0].each do |key, value|
      if i != 0
         error_message += ", "
      end
      error_message += "#{value.to_s} (#{key.to_s})"
   end
   
   raise StandardError, error_message
end

def create_auth_token(auth)
   require 'base64'
   require 'openssl'
   
   auth.api_key + "," + Base64.strict_encode64(OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), auth.secret_key, auth.uuid))
end

def send_http_request(url, http_method, headers, body)
   require 'net/http'
   require 'json'
   
   uri = URI.parse(URI.encode(url))
   http = Net::HTTP.new(uri.host, uri.port)
   
   case http_method
   when "POST"
      req = Net::HTTP::Post.new(uri)
      req.body = body.to_json
   when "PUT"
      req = Net::HTTP::Put.new(uri)
      req.body = body.to_json
   when "DELETE"
      req = Net::HTTP::Delete.new(uri)
   else
      req = Net::HTTP::Get.new(uri)
   end
   
   if headers != nil
      headers.each do |header, value|
         req[header] = value
      end
   end
   
   http.use_ssl = (uri.scheme == "https")
   
   response = http.request(req)
   result = Hash.new
   result["body"] = response.body
   result["code"] = response.code.to_i
   result["content-type"] = response["content-type"]
   return result
end

def convert_json_to_apps_array(json)
   apps_array = Array.new
   json.each do |app|
      apps_array.push(Dav::App.new(app))
   end
   return apps_array
end

def convert_json_to_tables_array(json)
   tables_array = Array.new
   json.each do |table|
      tables_array.push(Dav::Table.new(table))
   end
   return tables_array
end

def convert_json_to_events_array(json)
   events_array = Array.new
   json.each do |event|
      events_array.push(Dav::Event.new(event))
   end
   return events_array
end

def convert_json_to_event_logs_array(json)
   event_logs_array = Array.new
   json.each do |log|
      event_logs_array.push(Dav::EventLog.new(log))
   end
   return event_logs_array
end

def convert_json_to_archives_array(json)
   archives_array = Array.new
   json.each do |archive|
      archives_array.push(Dav::Archive.new(archive))
   end
   return archives_array
end

def convert_json_to_table_objects_array(json)
   table_objects_array = Array.new
   json.each do |obj|
      table_objects_array.push(Dav::Object.new(obj))
   end
   return table_objects_array
end