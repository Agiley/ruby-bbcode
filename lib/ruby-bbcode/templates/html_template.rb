module RubyBBCode::Templates
  # This class is designed to help us build up the HTML data.  It starts out as a template such as...
  #   @opening_part = '<a href="%url%">%between%'
  #   @closing_part = '</a>'
  # and then slowly turns into...
  #   @opening_part = '<a href="http://www.blah.com">cool beans'
  #   @closing_part = '</a>'
  class HtmlTemplate
    attr_accessor :opening_part, :closing_part

    def initialize(node)
      @node = node
      @tag_definition = node.definition # tag_definition
      @opening_part = node.definition[:html_open].dup
      @closing_part = node.definition[:html_close].dup
    end

    def inlay_between_text!
      @opening_part.gsub!('%between%',@node[:between]) if between_text_goes_into_html_output_as_param?  # set the between text to where it goes if required to do so...
    end

    def inlay_inline_params!
      # Get list of paramaters to feed
      match_array = @node[:params][:tag_param].scan(@tag_definition[:tag_param])[0]

      # for each parameter to feed
      match_array.each.with_index do |match, i|
        if i < @tag_definition[:tag_param_tokens].length

          # Substitute the %param% keyword for the appropriate data specified
          @opening_part.gsub!("%#{@tag_definition[:tag_param_tokens][i][:token].to_s}%",
                    @tag_definition[:tag_param_tokens][i][:prefix].to_s +
                      match +
                      @tag_definition[:tag_param_tokens][i][:postfix].to_s)
        end
      end
    end

    def inlay_closing_part!
      @closing_part.gsub!('%between%',@node[:between]) if @tag_definition[:require_between]
    end

    def remove_unused_tokens!
      @tag_definition[:tag_param_tokens].each do |token|
        @opening_part.gsub!("%#{token[:token]}%", '')
      end
    end

    private

    def between_text_goes_into_html_output_as_param?
      @tag_definition[:require_between]
    end
  end
end