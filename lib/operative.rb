class Operative < WeewarSpy::Spy
  def initialize(options = {})
    raise 'Must pass a hash of options.' if options.empty?
    super(options)
  end
end
