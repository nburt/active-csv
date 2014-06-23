class Things < ActiveCSV::Base

  def self.all
    rows = CSV.read(self.file_path, headers: true)
    rows.map do |row|
      new(row)
    end
  end

  def self.first
    self.all.first
  end

  def self.last
    self.all.last
  end

  def self.where(&block)
    self.all.select &block
  end

  def self.order(&block)
    self.all.sort_by &block
  end

end