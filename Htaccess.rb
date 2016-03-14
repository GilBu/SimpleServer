#!/usr/bin/ruby

require_relative 'http/config/ConfigFile'

class Htaccess < ConfigFile
    def initialize(config_lines)
        super(config_lines)
    end
    
    def auth_user_file
        @config = Hash.new

        # Split config lines into key value pairs.
        @lines.each do |line|
                #p line.split(' ')[0]
                @config[line.split(' ')[0]] = line.split(' ')[1].delete("\"")
            end
        @config['AuthUserFile']
    end
end
