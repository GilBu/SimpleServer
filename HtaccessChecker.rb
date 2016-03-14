#!/usr/bin/ruby

require 'pathname'
require 'digest'
require_relative 'Htaccess'

class HtaccessChecker
    def initialize(path, headers, httpd_config)
        @path = path
        @headers = headers
	@httpd_config = httpd_config
    end

    def protected?
        if @path != nil
            exists?(@httpd_config.access_file)
            if @htaccess_path != nil
                @htaccess_file = Htaccess.new(read_config_file(@htaccess_path))
                true
            else
                false
            end
        end
    end

    def can_authorize?
        exists?(".htpasswd")
    end

    def authorized?
        users = {}
        # Open and read values from auth file into a hash.
        read_config_file(@htaccess_file.auth_user_file).each do |line|
             user, hashval = line.split(':')
             users[user] = hashval.gsub(/{SHA}/,'').delete("\n")
        end
        # If the hash contains the decode password, return true.
        if users.has_value?(Digest::SHA1.base64digest(@headers["Authorization"]))
            true
        else
           false
        end
    end

# Checks if a file exists in a diretory structure.
  private def exists?(file_name)
      #root = "#{@httpd_config.document_root}"
      root = ''
      @path.split('/').each do |directory|
            root << directory << '/'
            # Prints the series of directories being searched for htaccess.
#            p "#{root}"
              if Pathname.new(File::join(root, file_name)).exist?
                @htaccess_path = "#{root}/#{file_name}"
              # htaccess found.
              return true
            end
        end

        # No htaccess found.
        return false
  end

        # Private:  Splits a config file's lines into an array.
    #
    # config_file - The name of the config file.
    #
    # Examples
    #
    #   read_config_file("httpd.conf")
    #   # => ["Line One", "Line Two", "Line Three"]
    #
    # Returns an array containing the file's line.
    private def read_config_file(config_path)
        # Open file and split into an array.
        config_array = Array.new
        File::open(config_path, "r") do |file|
            file.each do |line|
                config_array.push line
            end
        end
            
        # Return the array.
        config_array 
    end
end
