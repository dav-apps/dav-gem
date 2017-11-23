module Dav
   API_URL = "https://rails-backend-dav2070.c9users.io/v1/";
   #API_URL = "http://dav-backend.westeurope.cloudapp.azure.com/v1/";

   class Auth
      attr_accessor :api_key, :secret_key, :uuid, :dev_user_id, :dev_id
      
      def initialize(api_key: "", secret_key: "", uuid: "", dev_user_id: nil, dev_id: nil)
         @api_key = api_key
         @secret_key = secret_key
         @uuid = uuid
         @dev_user_id = dev_user_id
         @dev_id = dev_id
      end
      
      def login(email, password)
         # Send login request
         login_url = API_URL + 'users/login?email=' + email + '&password=' + password
         login_result = send_http_request(login_url, "GET", {"Authorization" => create_auth_token(self)}, nil)
         if login_result["code"] == 200
            jwt = JSON.parse(login_result["body"])["jwt"]
            user_id = JSON.parse(login_result["body"])["user_id"]
            
            # Get the user details with the user id and create new User object
            get_user_url = API_URL + 'users/' + user_id.to_s
            get_result = send_http_request(get_user_url, "GET", {"Authorization" => jwt}, nil)
            if get_result["code"] == 200
               user = User.new(JSON.parse get_result["body"])
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
      
      def signup
         
      end
   end
   
   class User
      attr_accessor :email, :username, :confirmed, :email_confirmation_token, :password_confirmation_token, :new_email, :avatar_file_extension, :jwt, :id
      
      def initialize(attributes)
         @id = attributes["id"]
         @email = attributes["email"]
         @username = attributes["username"]
         @confirmed = attributes["confirmed"]
         @email_confirmation_token = attributes["email_confirmation_token"]
         @password_confirmation_token = attributes["password_confirmation_token"]
         @new_email = attributes["new_email"]
         @avatar_file_extension = attributes["avatar_file_extension"]
      end
      
      def self.get(jwt, user_id)
         url = Dav::API_URL + 'users/' + user_id.to_s
         result = send_http_request(url, "GET", {"Authorization" => jwt}, nil)
         if result["code"] == 200
            user = User.new(JSON.parse result["body"])
         else
            puts "There was an error: "
            puts result["code"]
            puts result["body"]
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
   
   auth.api_key + "," + Base64.strict_encode64(OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), 
            auth.secret_key, auth.dev_id.to_s + "," + auth.dev_user_id.to_s + "," + auth.uuid.to_s))
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
   return result
end