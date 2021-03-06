module RubyBBCode
  # Provides the official/default BBCode tags as stated by http://www.bbcode.org/reference.php
  module Tags
    # tagname => tag, HTML open tag, HTML close tag, description, example
    # All of these entrys are represented as @dictionary in the classes (or as the variable tags)
    # A single item from this file (eg the :b entry) is refered to as a @definition
    @@tags = {
      :b => {
        :html_open => '<strong>', :html_close => '</strong>',
        :description => 'Make text bold',
        :example => 'This is [b]bold[/b].'},
      :i => {
        :html_open => '<em>', :html_close => '</em>',
        :description => 'Make text italic',
        :example => 'This is [i]italic[/i].'},
      :u => {
        :html_open => '<u>', :html_close => '</u>',
        :description => 'Underline text',
        :example => 'This is [u]underlined[/u].'},
      :s => {
        :html_open => '<span style="text-decoration:line-through;">', :html_close => '</span>',
        :description => 'Strike-through text',
        :example => 'This is [s]wrong[/s] good.'},
      :center => {
        :html_open => '<div style="text-align:center;">', :html_close => '</div>',
        :description => 'Center a text',
        :example => '[center]This is centered[/center].'},
      :ul => {
        :html_open => '<ul>', :html_close => '</ul>',
        :description => 'Unordered list',
        :example => '[ul][li]List item[/li][li]Another list item[/li][/ul].',
        :only_allow => [ :li, "*".to_sym ]},
      :code => {
        :html_open => '<pre>', :html_close => '</pre>',
        :description => 'Code block with mono-spaced text',
        :example => 'This is [code]mono-spaced code[/code].'},
      :ol => {
        :html_open => '<ol>', :html_close => '</ol>',
        :description => 'Ordered list',
        :example => '[ol][li]List item[/li][li]Another list item[/li][/ol].',
        :only_allow => [ :li, "*".to_sym ]},
      :li => {
        :html_open => '<li>', :html_close => '</li>',
        :description => 'List item',
        :example => '[ul][li]List item[/li][li]Another list item[/li][/ul].',
        :only_in => [ :ul, :ol ]},
      :list => {
        :html_open => '<ul>', :html_close => '</ul>',
        :description => 'Unordered list',
        :example => '[list][*]List item[*]Another list item[/list].',
        :only_allow => [ "*".to_sym ]},
      "*".to_sym => {
        :html_open => '<li>', :html_close => '</li>',
        :description => 'List item',
        :example => '[list][*]List item[*]Another list item[/list].',
        :self_closable => true,
        :only_in => [ :list, :ul, :ol ]},
      :img => {
        :html_open => '<img src="%between%" %width%%height%alt="" />', :html_close => '',
        :description => 'Image',
        :example => '[img]http://www.google.com/intl/en_ALL/images/logo.gif[/img].',
        :only_allow => [],
        :require_between => true,
        :allow_quick_param => true, :allow_between_as_param => false,
        :quick_param_format => /^(\d*)x(\d*)$/,
        :param_tokens => [{:token => :width, :prefix => 'width="', :postfix => '" ' },
                              { :token => :height,  :prefix => 'height="', :postfix => '" ' } ],
        :quick_param_format_description => 'The image parameters \'%param%\' are incorrect, <width>x<height> excepted'},
      :url => {
        :html_open => '<a href="%url%">%between%', :html_close => '</a>',
        :description => 'Link to another page',
        :example => '[url]http://www.google.com/[/url].',
        :only_allow => [],
        :require_between => true,
        :allow_quick_param => true, :allow_between_as_param => true,
        :quick_param_format => /^((((http|https|ftp):\/\/)|\/).+)$/, :param_tokens => [{ :token => :url }],
        :quick_param_format_description => 'The URL should start with http:// https://, ftp:// or /, instead of \'%param%\'' },
      :quote => {
        :html_open => '<div class="quote">%author%', :html_close => '</div>',
        :description => 'Quote another person',
        :example => '[quote]BBCode is great[/quote]',
        :allow_quick_param => true, :allow_between_as_param => false,
        :quick_param_format => /(.*)/,
        :param_tokens => [{:token => :author, :prefix => '<strong>', :postfix => ' wrote:</strong>'}]},
      :size => {
        :html_open => '<span style="font-size: %size%px;">', :html_close => '</span>',
        :description => 'Change the size of the text',
        :example => '[size=32]This is 32px[/size]',
        :allow_quick_param => true, :allow_between_as_param => false,
        :quick_param_format => /(\d*)/,
        :param_tokens => [{:token => :size}]},
      :color => {
        :html_open => '<span style="color: %color%;">', :html_close => '</span>',
        :description => 'Change the color of the text',
        :example => '[color=red]This is red[/color]',
        :allow_quick_param => true, :allow_between_as_param => false,
        :quick_param_format => /(([a-z]+)|(#[0-9a-f]{6}))/i,
        :param_tokens => [{:token => :color}]},
      :youtube => {
        :html_open => '<object width="400" height="325"><param name="movie" value="http://www.youtube.com/v/%between%"></param><embed src="http://www.youtube.com/v/%between%" type="application/x-shockwave-flash" width="400" height="325"></embed></object>', :html_close => '',
        :description => 'Youtube video',
        :example => '[youtube]E4Fbk52Mk1w[/youtube]',
        :only_allow => [],
        :url_matches => [/youtube\.com.*[v]=([^&]*)/, /youtu\.be\/([^&]*)/, /y2u\.be\/([^&]*)/],
        :require_between => true},
      :vimeo => {
        :html_open => '<iframe src="http://player.vimeo.com/video/%between%?badge=0" width="500" height="281" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>',
        :html_close => '',
        :description => 'Vimeo video',
        :example => '[vimeo]http://vimeo.com/46141955[/vimeo]',
        :only_allow => [],
        :url_matches => [/vimeo\.com\/([^&]*)/],
        :require_between => true},
      :media => {
        :multi_tag => true,
        :supported_tags => [
          :youtube,
          :vimeo
        ]
      }
    }

    def self.tag_list
      @@tags
    end
  end
end
