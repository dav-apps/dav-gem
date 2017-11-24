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
         login_url = API_URL + "users/login?email=#{email}&password=#{password}"
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
      
      def signup(email, password, username)
         url = API_URL + "users/signup?email=#{email}&password=#{password}&username=#{username}"
         result = send_http_request(url, "POST", {"Authorization" => create_auth_token(self)}, nil)
         if result["code"] == 201
            JSON.parse result["body"]
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
   end
   
   class User
      attr_accessor :email, :username, :confirmed, :new_email, :old_email, :avatar_file_extension, :jwt, :id
      
      def initialize(attributes)
         @id = attributes["id"]
         @email = attributes["email"]
         @username = attributes["username"]
         @confirmed = attributes["confirmed"]
         @new_email = attributes["new_email"]
         @old_email = attributes["old_email"]
         @avatar_file_extension = attributes["avatar_file_extension"]
      end
      
      def self.get(jwt, user_id)
         url = Dav::API_URL + "users/#{user_id.to_s}"
         result = send_http_request(url, "GET", {"Authorization" => jwt}, nil)
         if result["code"] == 200
            user = User.new(JSON.parse result["body"])
         else
            raise_error(JSON.parse result["body"])
         end
      end
      
      def update(properties)
         url = Dav::API_URL + "users"
         result = send_http_request(url, "PUT", {"Authorization" => @jwt, "Content-Type" => "application/json"}, properties)
         if result["code"] == 200
            @email = JSON.parse(result["body"])["email"]
            @username = JSON.parse(result["body"])["username"]
            @confirmed = JSON.parse(result["body"])["confirmed"]
            @new_email = JSON.parse(result["body"])["new_email"]
            @old_email = JSON.parse(result["body"])["old_email"]
            @avatar_file_extension = JSON.parse(result["body"])["avatar_file_extension"]
         else
            raise_error(JSON.parse result["body"])
         end
      end
      
      def self.send_verification_email(email)
         url = Dav::API_URL + "users/send_verification_email?email=#{email}"
         result = send_http_request(url, "POST", nil, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
      
      def self.send_password_reset_email(email)
         url = Dav::API_URL + "users/send_password_reset_email?email=#{}"
         result = send_http_request(url, "POST", nil, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
      
      def self.save_new_password(id, password_confirmation_token)
         url = Dav::API_URL + "users/#{id}/save_new_password/#{password_confirmation_token}"
         result = send_http_request(url , "POST", nil, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
      
      def self.save_new_email(id, email_confirmation_token)
         url = Dav::API_URL + "users/#{id}/save_new_email/#{email_confirmation_token}"
         result = send_http_request(url, "POST", nil, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
      
      def self.reset_new_email(id)
         url = Dav::API_URL + "users/#{id}/reset_new_email"
         result = send_http_request(url, "POST", nil, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
      
      def self.confirm(id, email_confirmation_token)
         url = Dav::API_URL + "users/#{id}/confirm?email_confirmation_token=#{email_confirmation_token}"
         result = send_http_request(url, "POST", {"Authorization" => @jwt}, nil)
         if result["code"] == 200
            @confirmed = true
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
      
      def delete
         url = Dav::API_URL + "users"
         result = send_http_request(url, "DELETE", {"Authorization" => @jwt}, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse result["body"])
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