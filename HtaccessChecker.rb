#!/usr/bin/ruby

require 'pathname'

class HtaccessChecker
    def initialize(path)
        @path = path
    end
    
    def protected?
        # Check if there is an htaccess file in the requested
        # resource root.
        if Pathname.new(File::join(@path, ".htaccess")).exist?
            p "htaccess file exists..."
        else
            p "no htaccess file..."
        end
    end

    def to_s
        @path.class
    end

    def can_authorize?

    end

    def authorized?

    end

end
