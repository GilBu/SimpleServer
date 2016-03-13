#!/usr/bin/ruby

class Htaccess < ConfigFile
    def initialize(config_lines)
        super(config_lines)
    end
    
    def auth_user_file
        @config = Hash.new

        # Split config lines into key value pairs.
        @lines.each do |line|
            @config[line[0]] = line[1]
        end
    end
end
