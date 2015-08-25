require 'test_helper'

class GoogleApiClientBasicTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::GoogleApiClientBasic::VERSION
  end

  def test_run
    puts GoogleApiClientBasic.run
  end

  def test_get_access_token
    puts GoogleApiClientBasic.get_access_token
  end
end
