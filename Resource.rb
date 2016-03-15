#!/usr/bin/ruby

class Resource
    attr_reader :uri, :http_conf, :mime_types

    def initialize(uri, http_conf, mime_types)
        @uri = uri
        @http_conf = http_conf
        @mime_types = mime_types
    end

    # Return the absolute path of the resource.
    def resolve
       # Isolate uri directory path.
       dir_path = @uri[/^\/[\S\/]*\//] if @uri != nil
       # Check if uri directory path is aliased.
       if @http_conf.alias(dir_path) != nil
            # Uri directory path was aliased. Replace the alias
            # and store the uri it points to.
            path = "#{@uri.sub(dir_path, @http_conf.alias(@uri[dir_path]))}"
       else
            # Not aliased.  Store the uri path to be resolved.
            path = "#{@http_conf.document_root}#{@uri[1..-1]}" if @uri != nil
       end

       # If the uri is a directory path, append the index file. Else, it is
       # an absolute path to the file being resolved.
       if path != nil && path[-1].eql?('/')
          #p path
            @uri = path << "index.html"
       else
           #p path
           @uri = path
       end
    end

    # Returns resource mime_type.
    def mime_type
        # Split uri on the extension and take the last element
        # element from the resulting array.
        if @mime_types != nil
            @mime_types.for(@uri.split('.')[-1])
        end
    end

    # Return true if a script resource was requested.
    def script?
        @uri.include?(@http_conf.script_alias("/cgi-bin/"))
    end
end
