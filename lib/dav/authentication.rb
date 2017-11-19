module Dav
   API_URL = "https://rails-backend-dav2070.c9users.io/v1/";
   #API_URL = "http://dav-backend.westeurope.cloudapp.azure.com/v1/";

   class Auth
      attr_accessor :api_key, :secret_key, :uuid, :dev_user_id, :dev_id
      
      def initialize(attributes)
         @api_key = attributes["api_key"]
         @secret_key = attributes["secret_key"]
         @uuid = attributes["uuid"]
         @dev_user_id = attributes["dev_user_id"]
         @dev_id = attributes["dev_id"]
      end
      
      def login(email, password)
         # Send login request
         login_url = API_URL + 'users/login?email=' + email + '&password=' + password
         json = send_http_request(login_url, "GET", {"Authorization" => create_auth_token(self)}, nil)
         jwt = json["jwt"]
         user_id = json["user_id"]
         
         # Get the user details with the user id and create new User object
         get_user_url = API_URL + 'users/' + user_id.to_s
         user = User.new(send_http_request(get_user_url, "GET", {"Authorization" => jwt}, nil))
         user.jwt = jwt
         user.id = user_id
         user
      end
      
      def signup
         
      end
   end
   
   class User
      attr_accessor :email, :username, :confirmed, :email_confirmation_token, :password_confirmation_token, :new_email, :avatar_file_extension, :jwt, :id
      
      def initialize(attributes)
         @email = attributes["email"]
         @username = attributes["username"]
         @confirmed = attributes["confirmed"]
         @email_confirmation_token = attributes["email_confirmation_token"]
         @password_confirmation_token = attributes["password_confirmation_token"]
         @new_email = attributes["new_email"]
         @avatar_file_extension = attributes["avatar_file_extension"]
      end
   end
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
   
   headers.each do |header, value|
      req[header] = value
   end
   
   #if auth_header
   #   req['Authorization'] = auth_header
   #end
   http.use_ssl = (uri.scheme == "https")
   response = JSON.parse http.request(req).body
end