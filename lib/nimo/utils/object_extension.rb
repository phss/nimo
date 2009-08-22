require "ostruct"

class Object
  
  # Creates a new object from a hash. The hash keys will became attribute names, and
  # the respective values will be the attribute's value.
  #
  # Example:
  #   obj = Object.from_hash({:a => 1, :b => 42})
  #   puts obj.a # 1
  #   puts obj.b # 42
  #    
  def self.from_hash(hash)
    OpenStruct.new(hash)
  end
  
end