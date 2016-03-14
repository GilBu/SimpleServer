#!/usr/bin/ruby

require_relative 'http/Response'
require_relative 'HtaccessChecker'

class ResponseFactory
    #  Call like a static method =  ResponseFactory.create(http_request, resource)
    def self.create(request, resource, httpd_config)
        # Check request format is valid. If not throw a 400 response.
        p "Resource: #{resource.resolve}"
        p "MimeType: #{resource.mime_type}"
        htaccessChecker = HtaccessChecker.new(resource.uri, request.headers, httpd_config)
        if htaccessChecker.protected?
            p "Protected directory! Checking authorization header."
            # Check for Authorization header.
            if request.headers["Authorization"] != nil
                # Check if htpasswd is present.
                if htaccessChecker.can_authorize?
                    # Validate user.
                    if htaccessChecker.authorized?
                        p "Authorized user."
                        # Check if file exists.
                        if Pathname.new(resource.uri).exist?
                            return Response.new(200, "File exists.")
                        else
                            return Response.new(404, "File does not exist")
                        end
                    else
                        p "Unauthorized user."
                        return Response.new(403, "Not Authorized.")
                    end
                else
                    # No htpasswd file found.
                    p "No htpasswd file found."
                    return Response.new(401, "No htpasswd.")
                end
            else
                p "Requesting Authorization header."
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
            if Pathname.new(resource.uri).exist?
                return Response.new(200, "File exists.")
            else
                return Response.new(404, "File does not exist")
            end
        end
        # Build and send response.
    end
end
