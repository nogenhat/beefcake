require 'beefcake/message'

class SimpleMessage < Beefcake::Message
  # Fields are sotred by `fn` for encoding.
  # It's probably uncommon to have an optional
  # field set before a required.  But it makes
  # testing for errors easier.
  optional :a, :string, 1
  required :b, :int32,  2
end

class MessageTest < Test::Unit::TestCase
  def test_encode
    msg = SimpleMessage.new :a => "testing", :b => 2
    assert_equal "\012\007testing\020\002", msg.encode("")
  end

  def test_encode_null_optional
    msg = SimpleMessage.new :b => 1
    assert_equal "\020\001", msg.encode("")
  end

  def test_encode_null_required
    msg = SimpleMessage.new :a => "testing"
    encoded = ""
    assert_raise Beefcake::Message::MissingField do
      msg.encode(encoded)
    end
    assert_equal "", encoded
  end

  def test_decode
    msg = SimpleMessage.new :a => "testing", :b => 2
    encoded = msg.encode("")
    decoded = SimpleMessage.decode(encoded)

    assert_equal msg.a, decoded.a
    assert_equal msg.b, decoded.b
  end
end
