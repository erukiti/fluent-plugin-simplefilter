require 'helper.rb'

class SimplefilterOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    file_exists ./test_exists
    tag test_filtered
  ]
  # CONFIG = %[
  #   path #{TMP_DIR}/out_file_test
  #   compress gz
  #   utc
  # ]

  def create_driver(conf = CONFIG, tag='test')
    Fluent::Test::OutputTestDriver.new(Fluent::SimplefilterOutput, tag).configure(conf)
  end

  def test_filtered?
    d = create_driver
    File.unlink(d.instance.file_exists) if File.exist?(d.instance.file_exists)
    assert_equal false, d.instance.filtered?
    open(d.instance.file_exists, "w").close
    assert_equal true, d.instance.filtered?
    File.unlink(d.instance.file_exists) if File.exist?(d.instance.file_exists)
  end


  def test_configure
    d = create_driver

    #### set configurations
    # d = create_driver %[
    #   path test_path
    #   compress gz
    # ]
    #### check configurations
    # assert_equal 'test_path', d.instance.path
    # assert_equal :gz, d.instance.compress
  end

  def test_format
    d = create_driver

    # time = Time.parse("2011-01-02 13:14:15 UTC").to_i
    # d.emit({"a"=>1}, time)
    # d.emit({"a"=>2}, time)

    # d.expect_format %[2011-01-02T13:14:15Z\ttest\t{"a":1}\n]
    # d.expect_format %[2011-01-02T13:14:15Z\ttest\t{"a":2}\n]

    # d.run
  end

  def test_write
    d = create_driver

    # time = Time.parse("2011-01-02 13:14:15 UTC").to_i
    # d.emit({"a"=>1}, time)
    # d.emit({"a"=>2}, time)

    # ### FileOutput#write returns path
    # path = d.run
    # expect_path = "#{TMP_DIR}/out_file_test._0.log.gz"
    # assert_equal expect_path, path
  end

  def test_emit
    d = create_driver
    d.run do 
      File.unlink(d.instance.file_exists) if File.exist?(d.instance.file_exists)
      d.emit({'key' => 'hoge'}, Time.parse("2012-03-03 00:00:00 UTC").to_i)
      open(d.instance.file_exists, "w").close
      d.emit({'key' => 'fuga'}, Time.parse("2012-03-03 00:00:00 UTC").to_i)
      File.unlink(d.instance.file_exists) if File.exist?(d.instance.file_exists)
    end
    assert_equal 1, d.emits.size
    assert_equal ['test_filtered', Time.parse("2012-03-03 00:00:00 UTC").to_i, {'key' => 'hoge'}], d.emits[0]
  end
end

