require File.dirname(__FILE__) + '/test_helper.rb'

class MaRuKuTest < Test::Unit::TestCase
  def test_should_not_execute_each_and_every_code_environment
    doc = Maruku.new(%q{    THIS_CONSTANT_WILL_NOT_BE_DEFINED = true})

    output = %q{<pre><code>THIS_CONSTANT_WILL_NOT_BE_DEFINED = true</code></pre>}

    assert_equal output, doc.to_html 
    assert !Object.const_defined?("THIS_CONSTANT_WILL_NOT_BE_DEFINED")
  end

  def test_should_execute_code_with_metadata
    doc = Maruku.new(%q{
    TEST_WORKS = true
{: execute}})

    output = %q{<pre><code>TEST_WORKS = true</code></pre>}

    assert_equal output, doc.to_html 
    assert Object.const_defined?("TEST_WORKS")
    assert TEST_WORKS
  end
  
  def test_should_attach_output_if_requested
    doc = Maruku.new(%q{
    1 + 1 == 2
{: execute attach_output}})

    output = %q{<pre><code>1 + 1 == 2
&gt;&gt; true</code></pre>}

    assert_equal output, doc.to_html 
  end
end

class LiterateMarukuTest < Test::Unit::TestCase
  def setup
    @dirname = File.dirname(__FILE__)
    @base_filename = "test_document"

    @mkd_filename =  File.join(@dirname, @base_filename + ".mkd")
    @html_filename = File.join(@dirname, @base_filename + ".html")

    teardown
  end

  def teardown
    File.delete(@html_filename) if File.exists?(@html_filename)
  end

  def test_require_should_execute_annotated_code_environments
    LiterateMaruku.require(@mkd_filename)
    assert $this_code_block_will_be_executed 
  end

  def test_require_should_not_execute_every_code_environment
    LiterateMaruku.require(@mkd_filename)
    assert !$this_code_block_will_not_be_executed 
  end

  def test_require_should_generate_an_html_file
    LiterateMaruku.require(@mkd_filename, :output => @dirname)
    assert File.exists?(@html_filename)
  end

  def test_require_should_raise_load_error_for_missing_files
    assert_raise(LoadError) do
      LiterateMaruku.require("missing_file.mkd")
    end
  end
end
