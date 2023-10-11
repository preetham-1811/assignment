require 'test_helper'

class QuotationTest < ActiveSupport::TestCase
  test "search" do
    assert Quotation.search(nil)
  end
end
