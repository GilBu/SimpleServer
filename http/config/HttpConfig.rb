#!/usr/bin/ruby

require_relative "ConfigFile.rb"

class HttpConfig < ConfigFile
    def initialize(config_lines)
        super(config_lines)
    end

    def process_lines
        @config = Hash.new
        @script_alias = Hash.new
        @alias = Hash.new

        @lines.each do |line|
            if line[0].match("ScriptAlias")
               @script_alias[line[1].delete("\"")] = line[2].delete("\"")
            elsif line[0].match("Alias")
                @alias[line[1].delete("\"")] = line[2].delete("\"")
            else
                @config[line[0]] = line[1].delete("\"")
            end
        end

        self
    end

    def listen
        @config["Listen"]
    end

    def document_root
        @config["DocumentRoot"]
    end

    def access_file
        @config["AccessFileName"]
    end

    def server_root
        @config["ServerRoot"]
    end

    def log_file
        @config["LogFile"]
    end

    def script_alias(sym_link)
        #sym_link
        @script_alias[sym_link]
    end

    def alias(sym_link)
        @alias[sym_link]
    end

end
