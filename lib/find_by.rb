class Module
  def create_finder_methods(*attributes)
    # Your code goes here!
    # Hint: Remember attr_reader and class_eval
    attributes.each do |attribute|
      finder_method = %Q{
        def find_by_#{attribute}(val)
          #{self}.all.select{|p| p.#{attribute} == val}.first
        end
      }
      instance_eval(finder_method)
    end
  end
end
