#!/usr/bin/ruby

class Resource
    def initialize(uri, http_conf, mime_types)
        @uri = uri
        @http_conf = http_conf
        @mime_types = mime_types
    end

    # Return the absolute path of the resource.
    def resolve
        "http_conf.document_root#{@uri}" 
    end

    # Return resource mime_type.
    def mime_type
        # Split uri on the extension and take the last element
        # element from the resulting array.
        @uri.split('.')[-1]
    end

    # Return true if a script resource was requested.
    def script?
        # Implement me.
    end
end
