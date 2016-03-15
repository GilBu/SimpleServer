#!/usr/bin/ruby

class ConfigFile

    def initialize(new_config)
        @lines = new_config
    end

    # Split array of line into array of tokens.
    def load
        @lines.select! do |line|
            line.strip.length != 0
        end.select! do |line|
            line[0] != '#'
        end.map! do |line|
            line.split(" ")
        end

        self
    end

end
