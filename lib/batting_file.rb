require 'csv'
require 'pry'
require 'pry-byebug'

class BattingFile
  attr_accessor :data, :years

  def initialize(file=nil)
    @data = IO.read(file) if file
  end

  def read
    @years ||= YearCollection.new CSV.parse(@data, headers: true).map{|year| Year.new(year) }
  end

  def self.read_safe(file)
    if(!@years)
      years = Array.new
      #skip headers
      first_parsed = false
      CSV.open(file, "rb") do |output|
        loop do
          begin
            break unless row = output.shift
            if !first_parsed
              first_parsed = true
            else
              years << Year.new(row)
            end
          rescue
            puts "Malformed Data Found"
            puts $!.message
          end
        end
      end
    end
    @years = YearCollection.new(years)
  end

  def self.load(data)
    new.tap do |file|
      file.data = data
      file.read
    end
  end
end
