#!/usr/bin/ruby

class Htaccess < ConfigFile
    def initialize(config_lines)
        super(config_lines)
    end
    
    def auth_user_file
        # Implement me.
    end
end
