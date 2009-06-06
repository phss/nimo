require "ostruct"

class Object
  
  #
  # Creates a new object from a hash. The hash keys will became attribute names, and
  # the respective values will be the attribute's value.
  #
  def self.from_hash(hash)
    OpenStruct.new(hash)
  end
  
end