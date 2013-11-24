# Jekyll Terminal Tag
#
# This jekyll plugin implements a new tag "terminal", to place shell
# command line blocks in you posts.
#
# Source: http://github.com/xinpascal/jekyll_terminal_tag
# License: MIT
#
# Syntax:
#   {% terminal Title %}
#       Command line
#       Command line
#   {% endterminal %}
#
# Example:
#   {% terminal terminal examples %}
#       ~$ cd /opt
#       /opt$ pwd
#       /opt
# {% endterminal %}
#
# Author: Xin Ouyang
# Site: http://xinpascal.github.io/
#
module Jekyll
  module Tags
    class TerminalBlock < Liquid::Block
      include Liquid::StandardFilters

      SYNTAX = /^(.*)$/

      def initialize(tag_name, markup, tokens)
        super
	@title = $1
        if markup.strip =~ SYNTAX
	  @title = $1
        else
	  raise SyntaxError.new <<-eos
Syntax Error in tag 'highlight' while parsing the following markup:

  #{markup}

Valid syntax: terminal <title>
eos
        end
      end

      def render(context)
        output = \
          "<div class=\"unit golden-large terminal\">" \
            "<p class=\"title\">#{@title}</p>" \
            "<pre class=\"shell\">" 
        iscmd = false
        super.strip.each_line do |line|
          if iscmd
            output += \
              "<p class=\"line\">" \
                "<span class=\"command\">#{line}</span>" 
              "</p>"
            iscmd = (line =~ /\\$/) 
            next 
          end 
          iscmd = false
          if line.start_with?("~", "/", "[")
            path, prompt, command = line.partition(/[$#]/)
            if prompt != ""
              output += \
                "<p class=\"line\">" \
                  "<span class=\"path\">#{path}</span>" 
              if prompt == "$"
                output += \
                  "<span class=\"prompt\">#{prompt}</span>"
              else
                output += \
                  "<span class=\"superprompt\">#{prompt}</span>"
              end
              output += \
                  "<span class=\"command\">#{command}</span>" \
                "</p>"
              iscmd = (line =~ /\\$/) 
            else
              output += \
                "<p class=\"line\">" \
                  "<span class=\"output\">#{line}</span>" \
                "</p>"
            end
          else
            output += \
              "<p class=\"line\">" \
                "<span class=\"output\">#{line}</span>" \
              "</p>"
          end
        end

        output += "</pre>" \
          "</div>" \
          "<div class=\"clear\"></div>" 

        "#{output}"
      end

    end
  end
end

Liquid::Template.register_tag('terminal', Jekyll::Tags::TerminalBlock)
