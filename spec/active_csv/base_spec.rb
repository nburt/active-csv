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
    it "has a .all method that returns an array of ActiveCSV::Base objects" do
      Things.file_path = "./spec/fixtures/sample.csv"

      actual = Things.all

      expect(actual.length).to eq 3
      expect(actual.first.id).to eq "4"
      expect(actual.last.first_name).to eq "Bebe"
    end

    it "has a .first method that returns an object representing the first row in the csv file" do
      Things.file_path = "./spec/fixtures/sample.csv"

      actual = Things.first

      expect(actual.id).to eq "4"
      expect(actual.first_name).to eq "Joe"
    end

    it "has a .last method that returns an object representing the first row in the csv file" do
      Things.file_path = "./spec/fixtures/sample.csv"

      actual = Things.last

      expect(actual.id).to eq "5"
      expect(actual.first_name).to eq "Bebe"
    end

    it "has a .where method that returns a filtered array of objects" do
      Things.file_path = "./spec/fixtures/sample.csv"

      actual = Things.where { |thing| thing.first_name == "Joe" }

      expect(actual.length).to eq 2
      expect(actual.first.id).to eq "4"
      expect(actual.last.id).to eq "6"
      expect(actual.first.first_name).to eq "Joe"
    end

    it "has a .order method that will return an ordered array of objects" do
      Things.file_path = "./spec/fixtures/sample.csv"

      actual = Things.order { |thing| thing.id }

      expect(actual.first.id).to eq "4"
      expect(actual[1].id).to eq "5"
      expect(actual.last.id).to eq "6"
    end
  end

end