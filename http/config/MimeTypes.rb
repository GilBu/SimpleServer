#!/usr/bin/ruby

require_relative "ConfigFile.rb"

class MimeTypes < ConfigFile
    def initialize(config_lines)
        super(config_lines)
    end

    def process_lines
        @mime_types= Hash.new
        # Parse @lines into a hash
        # element 0 is the value.
        @lines.each do |line|
            value = line.delete_at(0)
            line.each do |key|
                @mime_types[key] = value
            end
        end

        self
    end

    def for(extension)
        @mime_types[extension]
    end

end
