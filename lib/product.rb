require_relative 'udacidata'

class Product < Udacidata
  attr_reader :id, :price, :brand, :name
  create_finder_methods :name, :brand
  def initialize(opts={})

    # Get last ID from the database if ID exists
    get_last_id
    # Set the ID if it was passed in, otherwise use last existing ID
    @id = opts[:id] ? opts[:id].to_i : @@count_class_instances
    # Increment ID by 1
    auto_increment if !opts[:id]
    # Set the brand, name, and price normally
    @brand = opts[:brand]
    @name = opts[:name] || opts[:product]
    @price = opts[:price]
  end

  def self.create(opts={})
    product = Product.new(opts)
    file = File.dirname(__FILE__) + "/../data/data.csv"
    CSV.open(file, "a+") do |csv|
      csv << ["#{product.id}", "#{product.brand}", "#{product.name}", "#{product.price}"] unless csv.map{|record| record.first.to_i}.include?(product.id)
    end
    return product
  end

  def self.all
    csv = load_csv
    csv.map{|record| Product.new(record.to_h)}
  end

  def self.first(n=1)
    n > 1 ? all.take(n) : all.first
  end

  def self.last(n=1)
    n > 1 ? all.reverse.take(n) : all.last
  end

  def self.find(id)
    all.fetch(id-1)
  end

  def self.destroy(id)
    file = File.dirname(__FILE__) + "/../data/data.csv"
    table = load_csv
    deleted = table.delete(id-1).to_h
    File.open(file, 'w') do |f|
      f.write(table.to_csv)
    end
    Product.new(deleted)
  end

  private

    # Reads the last line of the data file, and gets the id if one exists
    # If it exists, increment and use this value
    # Otherwise, use 0 as starting ID number
    def get_last_id
      file = File.dirname(__FILE__) + "/../data/data.csv"
      last_id = File.exist?(file) ? CSV.read(file).last[0].to_i + 1 : nil
      @@count_class_instances = last_id || 0
    end

    def auto_increment
      @@count_class_instances += 1
    end

    def self.load_csv
      file = File.dirname(__FILE__) + "/../data/data.csv"
      return CSV.table(file)
    end

end
