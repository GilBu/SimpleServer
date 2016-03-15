#!/usr/bin/ruby

require_relative 'http/Response'
require_relative 'HtaccessChecker'

class ResponseFactory
    #  Call like a static method =  ResponseFactory.create(http_request, resource)
    def self.create(request, resource, httpd_config)
        begin
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
                            begin 
                                handle_request(request, resource)
                            rescue
                                return Response.new(404, "Not Found")
                            end
                        else
                            p "Unauthorized user."
                            return Response.new(403, "Forbidden")
                        end
                    else
                        # No htpasswd file found.
                        p "No htpasswd file found."
                        return Response.new(401, "Unauthorized")
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
                if Pathname.new(resource.uri).exist? || request.verb.eql?("PUT")
                    # Check if file is a script.
                    begin
                        if resource.script?
                            # Execute script and return its contents in the body.
                            file = IO.popen(resource.uri)
                            file_contents = file.readlines
                            file.close
                            return Response.new(200, file_contents.join(' '), resource.mime_type)
                        else
                            # Determine request type and send proper response. 
                            p request.verb
                            handle_request(request, resource)
                        end
                    rescue
                        return Response.new(404, "Not Found")
                    end
                else
                    return Response.new(404, "Not Found")
                end
            end
            # Build and send response.
       rescue
            return Response.new(400, "Bad Request")
       end
    end

    def self.handle_request(request, resource)
        case request.verb
            when "GET"
                # Return file content.
                file = File.open(resource.uri, 'rb')
                file_content = file.read
                modified_time = file.mtime
                p file_content
                p modified_time
                return Response.new(200, file_content, resource.mime_type)
            when "HEAD"
                # Return the resource without the body.
                return Response.new(200, "", resource.mime_type)
            when "DELETE"
                # Delete the specified file.
                File.delete(resource.uri)
                # No response returned for deleted per docs.
                #return Response.new(204, "#{resource.uri} DELETED.")
            when "PUT"
                # Create the specified file.
                File.new(resource.uri, "w")
                return Response.new(201, "Created")
        end
    end

end
