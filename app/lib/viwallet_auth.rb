class ViwalletAuth
    ERROR_MESSAGES = {"EMAIL_NOT_CONFIRMED" => "Please Confirm your email.", "WRONG_INPUT_DATA" => "Invalid Credentials.", "EMAIL_INVALID" => "Please Enter a valid email.", "EMAIL_ALREADY_REGISTERED" => "Email already registered, Please login with your credentials.", "EMAIL_UNCONFIRMED" => "Please confirm your email and login.", "CANNOT_SEND_EMAIL" => "Please Enter a valid email.", "UNCONFIRMED_EMAIL_NOT_FOUND" => "Invalid Email or Email already verified."}
    def initialize
        @base_url = "https://exchange.viwallet.com/"
    end

    def register(data)
        path = "/gateway/public/register"
        register_response = http_post(path, data)
        unless register_response.code == "200"
            return OpenStruct.new(success?: false, message: "Internal error occured")
        end
        response_data = JSON.parse register_response.body

        if response_data["success"]
            return OpenStruct.new(success?: true)
        end

        message = ERROR_MESSAGES[response_data["errors"][0].keys[0]]
        message = "Please enter valid details." if message.empty?
        OpenStruct.new(success?: false, message: message)
    end

    def login(data)
        path = "/gateway/public/authenticate"
        login_response = http_post(path, data)
        unless login_response.code == "200"
            return OpenStruct.new(success?: false, message: "Internal error occured")
        end
        response_data = JSON.parse login_response.body

        if response_data["success"]
            return OpenStruct.new(success?: true)
        end

        message = ERROR_MESSAGES[response_data["errors"][0].keys[0]]
        message = "Invalid Credentials." if message.empty?
        OpenStruct.new(success?: false, message: message)
    end

    def resend_confirmation(data)
        path = "/gateway/public/resendConfirmation"
        resend_response = http_post(path, data)
        unless resend_response.code == "200"
            return OpenStruct.new(success?: false, message: "Internal error occured")
        end
        response_data = JSON.parse resend_response.body

        if response_data["success"]
            return OpenStruct.new(success?: true)
        end

        message = ERROR_MESSAGES[response_data["errors"][0].keys[0]]
        message = "Invalid Email." if message.empty?
        OpenStruct.new(success?: false, message: message)
    end

    def http_post(path, data)
        uri = URI.parse(@base_url)
        uri.path = path
    
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
    
        request = Net::HTTP::Post.new(uri)
        request['Content-Type'] = 'application/json'
        request.body = data.to_json
        https.request(request)
    end
end