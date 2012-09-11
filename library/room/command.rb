module Ariera
  class Room
    class Command < Message
      def initialize room, raw, output
        super room, raw

        # If command provided an formatted output version use it
        if output.respond_to? :xhtml and not output.xhtml.blank?
          raw.xhtml = output.xhtml

        # Command is going crazy and sending only string,
        # convert it to formmated message as well
        elsif output.kind_of? String
          raw.xhtml = output
        # Default to yellow formatted command body
        else

          self.formatted_body = "<span style=\"color: #eec803;\">#{raw.body}</span>"
        end
      end
    end
  end
end
