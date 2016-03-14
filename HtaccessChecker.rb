#!/usr/bin/ruby

require 'pathname'

class HtaccessChecker
    def initialize(path, headers)
        @path = path
        @headers = headers
    end
    
    def protected?
        root = ''
        # Document root is not avaible in this class
        # as its entry vector was not specified in the
        # the construction specs.  Entire path interated
        # through as a result. Not efficient.
        @path.split('/').each do |directory|
            root << directory << '/'
            # Prints the series of directories being searched for htaccess.
           # p "#{root}"
            if Pathname.new(File::join(root, ".htaccess")).exist?
                # htaccess found.
                return true
            end
        end 

        # No htaccess found.
        return false
    end

    def can_authorize?
        # Locate htpasswd
        root = ''
        # Document root is not avaible in this class
        # as its entry vector was not specified in the
        # the construction specs.  Entire path interated
        # through as a result. Not efficient.
        @path.split('/').each do |directory|
            root << directory << '/'
            # Prints the series of directories being searched for htaccess.
           # p "#{root}"
            if @htpasswd = Pathname.new(File::join(root, ".htpasswd")).exist? 
                # htpasswd found.
                return true
            end
        end

        return false
    end

    def authorized?
        p @htpasswd 
    end
end
