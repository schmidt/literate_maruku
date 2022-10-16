require 'literate_maruku/version'

require 'rexml'
require 'maruku'

module LiterateMaruku
  # The public interface to Literate Maruku
  #
  # Besides these methods, maruku itself is exented to handle the new meta-data
  # keywords. In your Markdown code use <tt>{: execute}</tt> to evaluate the
  # code block and <tt>{: execute attach_output}</tt> to evaluate the code and
  # attach the result to the generated document. If you need to execute code
  # that should not be rendered attach <tt>{: execute hide}</tt>.
  module ClassMethods
    # This accessor stores the binding, in which the code will be executed. By
    # default, this is the root context. Use the setter to change it, if you
    # would like to have all your code in a special context, a module for
    # example.
    attr_accessor :binding

    # <tt>file</tt> has to have a <tt>.mkd</tt> extension. The
    # <tt>LOAD_PATH</tt> will be used to find the file. It will be simply
    # executed. If called with <tt>:output => dir</tt>, html generated from the
    # markdown document will be stored in the given directory. The resulting
    # file name will include the basename of <tt>file</tt> and the
    # <tt>.html</tt> file extension.
    #
    # Additionally default values, that influence the code generation and
    # execution may be set.
    #
    #   LiterateMaruku.require("file.mkd", :output => ".",
    #                                      :attributes => {:execute => true})
    #
    # will enable execution for all code block per default, for example. Other
    # options are <tt>:attach_output</tt> and <tt>:hide</tt>.
    def require(file, options = {})
      document = generate_output(file)

      document.attributes.merge!(options[:attributes] || {})
      content = options[:inline] ? document.to_html : document.to_html_document
      store_in_file(File.basename(file, ".mkd"), content, options[:output])

      content
    end

  private
    def generate_output(file)
      Maruku.new(markdown_string(file))
    end

    def markdown_string(file)
      if File.exist?(file)
        filename = file
      else
        dir = $:.find{ |load_dir| File.exist?(File.join(load_dir, file)) }
        raise LoadError, "no such file to load -- #{file}" if dir.nil?

        filename = File.join(dir, file)
      end
      File.open(filename) { |f| f.readlines.join }
    end

    def store_in_file(file_base_name, string, directory)
      if directory
        File.open(File.join(directory, file_base_name + ".html"), "w") do |f|
          f.puts(string)
        end
      end
    end
  end

  extend ClassMethods
end

LiterateMaruku.binding = binding

# This is the basic module provided by Maruku, but Literate Maruku added three
# parameters to configure its behaviour.
#
# Set <tt>MaRuKu::Globals[:execute]</tt> to true, if you like to execute code
# block by default. To disable the execution for single blocks, add
# <tt>{: execute=false}</tt>.
#
# Set <tt>MaRuKu::Globals[:attach_output]</tt> to true, if you like to attach
# the results of code blocks by default. To disable this option for single
# blocks, add <tt>{: attach_output=false}</tt>.
#
# *Note*: These settings may also be configured on an instance basis, when
# calling <tt>LiterateMaruku#require</tt> with an attributes Hash.
module MaRuKu
  Globals[:execute] = false
  Globals[:attach_output] = false
  Globals[:hide] = false

  module Out # :nodoc: all
    module HTML
      unless instance_methods.include? "to_html_code_using_pre_with_literate"
        def to_html_code_using_pre_with_literate(source, code_lang=nil)
          if is_true?(:execute)
            value = eval(source, LiterateMaruku.binding)
            source += "\n>> " + value.inspect if is_true?(:attach_output)
          end
          to_html_code_using_pre_without_literate(source, code_lang) if !is_true?(:hide)
        end

        alias_method :to_html_code_using_pre_without_literate,
                     :to_html_code_using_pre
        alias_method :to_html_code_using_pre,
                     :to_html_code_using_pre_with_literate

      private
        def is_true?(key)
          get_setting(key) && get_setting(key) != "false"
        end
      end
    end
  end
end
