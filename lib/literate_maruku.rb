$:.unshift File.dirname(__FILE__)

require "rubygems"
gem "maruku"
require "maruku"

module LiterateMaruku
  # The public interface to Literate Maruku
  #
  # Besides these methods, maruku itself is exented to handle the new meta-data
  # keywords. In your Markdown code use <tt>{: execute}</tt> to evaluate the 
  # code block and <tt>{: execute attach_output}</tt> to evaluate the code and 
  # attach the result to the generated document. See our website or the tests 
  # for further examples.
  module ClassMethods
    # <tt>file</tt> has to have a <tt>.mkd</tt> extension. The LOAD_PATH will 
    # be used to find the file. It will be simply executed. If called with 
    # <tt>:output => dir</tt> html generated from the markdown document will 
    # be stored in the given directory. The resulting file name will include 
    # the basename of <tt>file</tt> and the <tt>.html</tt> file extension.
    def require(file, options = {})
      document = generate_output(file)
      store_in_file(File.basename(file, ".mkd"), document, options[:output])
      document 
    end

    private
    def generate_output(file)
      Maruku.new(markdown_string(file)).to_html_document
    end

    def markdown_string(file)
      dir = $:.find { |load_dir| File.exists?(File.join(load_dir, file)) }
      File.open(File.join(dir, file)){|f| f.readlines.join}
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

$literate_maruku_binding = binding

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
module MaRuKu
  Globals[:execute] = false
  Globals[:attach_output] = false
  Globals[:hide] = false

  module Out # :nodoc: all
    module HTML
      unless instance_methods.include? "to_html_code_using_pre_with_literate"
        def to_html_code_using_pre_with_literate(source)
          if get_setting(:execute)
            value = eval(source, $literate_maruku_binding)
            source += "\n>> " + value.inspect if get_setting(:attach_output)
          end
          to_html_code_using_pre_without_literate(source) if !get_setting(:hide)
        end

        alias_method :to_html_code_using_pre_without_literate,
                     :to_html_code_using_pre
        alias_method :to_html_code_using_pre,
                     :to_html_code_using_pre_with_literate
      end
    end
  end
end
