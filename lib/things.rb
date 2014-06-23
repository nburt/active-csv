class Things < ActiveCSV::Base

  def self.all
    rows = CSV.read(self.file_path, headers: true)
    rows.map do |row|
      new(row)
    end
  end

end