require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  # Your code goes here!
  @@file_path = File.dirname(__FILE__) + "/../data/data.csv"
  create_finder_methods :name, :brand

  def update(opts = {})
    new_brand = opts[:brand] || @brand
    new_name = opts[:name] || opts[:product] || @name
    new_price = opts[:price] || @price
    new_id = @id
    new_opts = Hash(id: new_id, brand: new_brand, name: new_name, price: new_price)
    Udacidata.destroy(new_id)
    return Product.create new_opts
  end

  def self.create(opts={})
    product = self.new(opts)
    CSV.open(@@file_path, "a+") do |csv|
      csv << ["#{product.id}", "#{product.brand}", "#{product.name}", "#{product.price}"] unless csv.map{|record| record.first.to_i}.include?(product.id)
    end
    return product
  end

  def self.all
    csv = self.load_csv
    csv.map{|record| Product.new(record.to_h)}
  end

  def self.first(n=1)
    n > 1 ? all.take(n) : all.first
  end

  def self.last(n=1)
    n > 1 ? all.reverse.take(n) : all.last
  end

  def self.find(id)
    product_found = all.find{|product| product.id == id}
    raise ProductNotFoundError, "Product ID does not exist!" if id > all.count || !product_found
    product_found
  end

  def self.where(opts={})
    key, val = opts.first
    all.select{|record| record.send(key) == val}
  end

  def self.destroy(id)
    table = self.load_csv
    product_found = all.find{|product| product.id == id}
    raise ProductNotFoundError, "Product ID does not exist!" if id > table.count || !product_found
    table.delete_if do |row|
      row[:id] == id
    end
    self.write_csv(table)
    product_found
  end

  private

  def self.load_csv
    return CSV.table(@@file_path)
  end

  def self.write_csv(table)
    File.open(@@file_path, 'w') do |f|
      f.write(table.to_csv)
    end
  end
end
