module CalendarHelper
  def has_t?(key)
    !t(key, exception_handler: lambda {|*_| nil}).nil?
  end
end