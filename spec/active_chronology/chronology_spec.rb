require 'spec_helper'
require 'active_record'

module ActiveChronology
  describe Chronology do
    let(:mock_class) { build_mock_class }
    let!(:mock_1) do
      mock_class.create!(
        timestamp_at: Time.now - 2.hours,
        datestamp_on: Date.today + 2.days
      )
    end
    let!(:mock_2) do
      mock_class.create!(
        timestamp_at: Time.now + 2.hours,
        datestamp_on: Date.today - 2.days
      )
    end

    before(:all) { create_table }
    after(:all) { drop_table }

    after { mock_class.destroy_all }

    describe '.chronological' do
      it 'orders by the given timestamp, ascending' do
        expect(mock_class.chronological).to eq [mock_1, mock_2]
      end
    end

    describe '.reverse_chronological' do
      it 'orders by the given timestamp, descending' do
        expect(mock_class.reverse_chronological).to eq [mock_2, mock_1]
      end
    end

    describe '.timestamp_before' do
      it 'returns records with a timestamp before the given time' do
        expect(mock_class.timestamp_before(Time.now)).to eq [mock_1]
      end
    end

    describe '.timestamp_after' do
      it 'returns records with a timestamp before the given time' do
        expect(mock_class.timestamp_after(Time.now)).to eq [mock_2]
      end
    end

    describe '.timestamp_between' do
      it 'returns records with a timestamp between the given times' do
        expect(mock_class.timestamp_between(Time.now - 4.hours, Time.now))
          .to eq [mock_1]
      end
    end

    describe '.datestamp_before' do
      it 'returns records with a datestamp before the given date' do
        expect(mock_class.datestamp_before(Date.today)).to eq [mock_2]
      end
    end

    describe '.datestamp_after' do
      it 'returns records with a timestamp before the given date' do
        expect(mock_class.datestamp_after(Date.today)).to eq [mock_1]
      end
    end

    describe '.datestamp_between' do
      it 'returns records with a datestamp between the given dates' do
        expect(mock_class.datestamp_between(Date.today - 4.days, Date.today))
          .to eq [mock_2]
      end
    end

    def build_mock_class
      Class.new(ActiveRecord::Base) do
        self.table_name = 'mock_table'
        reset_column_information

        include Chronology

        set_chronology :timestamp_at
        scope_by_timestamp :timestamp_at, :datestamp_on
      end
    end

    def create_table
      ActiveRecord::Base.connection.create_table :mock_table do |t|
        t.datetime :timestamp_at
        t.date :datestamp_on
      end
    end

    def drop_table
      ActiveRecord::Base.connection.drop_table :mock_table
    end
  end
end
