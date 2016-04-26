require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  # Your code goes here!
  @@file_path = File.dirname(__FILE__) + "/../data/data.csv"
  create_finder_methods :name, :brand

  def update(opts = {})
    @brand = opts[:brand]
    @name = opts[:name] || opts[:product]
    @price = opts[:price]
    table = self.class.load_csv
    table[self.id] = [self.id, self.brand, self.name, self.price]
    self.class.write_csv(table)
    return self
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
    all.fetch(id-1)
  end

  def self.where(opts={})
    key, val = opts.first
    all.select{|record| record.send(key) == val}
  end

  def self.destroy(id)
    table = self.load_csv
    deleted = table.delete(id-1).to_h
    self.write_csv(table)
    self.new(deleted)
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
