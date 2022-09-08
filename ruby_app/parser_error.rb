# test_files/ruby_app/parser_error.rb
class ParserError < StandardError
  def initialize(msg)
    super
  end
end