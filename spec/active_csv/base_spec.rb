require 'rspec'
require 'active_csv/base'
require 'csv'
require './lib/things.rb'

describe ActiveCSV::Base do

  it "can be initialized with nothing" do
    active_csv = ActiveCSV::Base.new
    expect(active_csv).to be_kind_of(ActiveCSV::Base)
    expect { active_csv.first_name }.to raise_exception(NoMethodError)
  end

  describe "attribute readers" do
    it "defines an attribute reader for every column in the csv" do
      row = CSV::Row.new(["name", "age"], ["joe", "24"])

      active_csv = ActiveCSV::Base.new(row)

      expect(active_csv.name).to eq("joe")
      expect(active_csv.age).to eq("24")
      expect(active_csv.respond_to?(:name)).to eq true
    end

    it "raises an error if the csv row doesn't have that column" do
      row = CSV::Row.new(["name", "age"], ["joe", "24"])

      active_csv = ActiveCSV::Base.new(row)

      expect { active_csv.first_name }.to raise_exception(NoMethodError)
      expect(active_csv.respond_to?(:first_name)).to eq false
    end

    it "returns nil if the value of the column is nil" do
      row = CSV::Row.new(["name", "age"], [nil, "24"])

      active_csv = ActiveCSV::Base.new(row)

      expect(active_csv.name).to eq(nil)
      expect(active_csv.age).to eq("24")
      expect(active_csv.respond_to?(:name)).to eq true
    end

    it "normalizes csv headers" do
      row = CSV::Row.new(["First     Name", "  aGe  ",], [nil, "24"])

      active_csv = ActiveCSV::Base.new(row)

      expect(active_csv.first_name).to eq(nil)
      expect(active_csv.age).to eq("24")
      expect(active_csv.respond_to?(:first_name)).to eq true
    end
  end

  describe ".file_path" do
    it "allows you to set the file path to the CSV" do
      klass = Class.new(ActiveCSV::Base) do
        self.file_path = "foo"
      end

      expect(klass.file_path).to eq("foo")
    end
  end

end

describe Things do

  describe "Things methods" do
    it ".all method that returns an array of ActiveCSV::Base objects" do
      Things.file_path = "./spec/fixtures/sample.csv"

      actual = Things.all

      expect(actual.length).to eq 2
      expect(actual.first.id).to eq "4"
      expect(actual.last.first_name).to eq "Bebe"
    end
  end

end