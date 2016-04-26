module Analyzable
  # Your code goes here!
  def average_price(entries)
    (entries.inject(0.0) {|sum, entry| sum + entry.price} / entries.count).round(2)
  end

  def print_report(entries)
    entries.map{|e| "#{e.id}. Brand: #{e.brand} Name: #{e.name} Price: #{e.price}"}.to_s
  end

  def count_by_name(entries)
    entries.group_by{|e| e.name}.map{|name, entries| [name, entries.count]}.to_h
  end

  def count_by_brand(entries)
    entries.group_by{|e| e.brand}.map{|brand, entries| [brand, entries.count]}.to_h
  end
end
