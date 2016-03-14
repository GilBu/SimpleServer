#!/usr/bin/ruby

require_relative 'http/Response'
require_relative 'HtaccessChecker'

class ResponseFactory
    #  Call like a static method =  ResponseFactory.create(http_request, resource)
    def self.create(request, resource, httpd_config)
        # Check request format is valid. If not throw a 400 response.
        p "Resource: #{resource.resolve}"
        p "MimeType: #{resource.mime_type}"
        #
       # p "HEADERS:#{@headers}"
        htaccessChecker = HtaccessChecker.new(resource.uri, request.headers, httpd_config)
        p "URI #{resource.uri}"
        if htaccessChecker.protected?
            p "Protected directory!"
            # Check for Authorization header.
            if request.headers["Authorization"] != nil
                p "Authorize headers present"
                # Check if htpasswd is present.
                if htaccessChecker.can_authorize?
                    # Validate user.
                    if htaccessChecker.authorized?
                        return Response.new(200, "Authorized.")
                    else
                        return Response.new(200, "Not Authorized.")
                    end
                else
                    return Response.new(200, "No htpasswd.")
                end
            else
                p "No Authorization header sending request."
                response = Response.new(401, "Unauthorized")
                response.headers["WWW-Authenticate"] = "Basic realm=\"CSc667\""
                return response
            end

            # else check un and pw against htpasswd.
            # if invalid, send 403 response
            # else check if file exists
        else
            p "Directory is NOT protected."
            # Check if file exists.
            #p "Resource: #{resource.resolve}"
            Response.new(200, "Response generated by ResponseFactory.")
        end
        # Build and send response.
    end
end
