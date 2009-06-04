class Object
  
  #
  # Creates a new object from a hash. The hash keys will became attribute names, and
  # the respective values will be the attribute's value.
  #
  # Got the tip from http://pullmonkey.com/2008/1/6/convert-a-ruby-hash-into-a-class-object
  #
  def self.from_hash(hash)
    hash.inject(Object.new) do |obj, entry|
      k, v = entry[0], entry[1]
      obj.instance_variable_set("@#{k}", v)
      obj.class.send(:define_method, k, proc { obj.instance_variable_get("@#{k}")})
      obj.class.send(:define_method, "#{k}=", proc { |v| obj.instance_variable_set("@#{k}", v)})
    end
  end
  
end