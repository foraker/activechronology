require 'spec_helper'
require 'active_record'

module ActiveChronology
  describe Chronology do
    let(:now) { Time.current }
    let(:today) { Date.current }

    let(:mock_class) { build_mock_class }
    let!(:mock_1) do
      mock_class.create!(
        timestamp_at: now - 2.hours,
        datestamp_on: today + 2.days
      )
    end
    let!(:mock_2) do
      mock_class.create!(
        timestamp_at: now,
        datestamp_on: today
      )
    end
    let!(:mock_3) do
      mock_class.create!(
        timestamp_at: now + 2.hours,
        datestamp_on: today - 2.days
      )
    end

    before(:all) { create_table }
    after(:all) { drop_table }

    after { mock_class.destroy_all }

    describe '.chronological' do
      it 'orders by the given timestamp, ascending' do
        expect(mock_class.chronological).to eq [mock_1, mock_2, mock_3]
      end
    end

    describe '.reverse_chronological' do
      it 'orders by the given timestamp, descending' do
        expect(mock_class.reverse_chronological).to eq [mock_3, mock_2, mock_1]
      end
    end

    describe '.timestamp_before' do
      it 'returns records with a timestamp before the given time' do
        expect(mock_class.timestamp_before(now)).to eq [mock_1, mock_2]
      end

      it 'excludes matching timestamps if exclusive' do
        expect(mock_class.timestamp_before(now, exclusive: true))
          .to eq [mock_1]
      end
    end

    describe '.timestamp_after' do
      it 'returns records with a timestamp after the given time' do
        expect(mock_class.timestamp_after(now)).to eq [mock_2, mock_3]
      end

      it 'excludes matching timestamps if exclusive' do
        expect(mock_class.timestamp_after(now, exclusive: true))
          .to eq [mock_3]
      end
    end

    describe '.timestamp_between' do
      it 'returns records with a timestamp between the given times' do
        expect(mock_class.timestamp_between(now - 4.hours, now))
          .to eq [mock_1, mock_2]
      end

      it 'excludes matching beginning timestamps if exclusive' do
        expect(mock_class.timestamp_between(now - 2.hours, now + 1.hour, exclusive: true))
          .to eq [mock_2]
      end

      it 'excludes matching ending timestamps if exclusive' do
        expect(mock_class.timestamp_between(now - 4.hours, now, exclusive: true))
          .to eq [mock_1]
      end
    end

    describe '.datestamp_before' do
      it 'returns records with a datestamp before the given date' do
        expect(mock_class.datestamp_before(today)).to eq [mock_2, mock_3]
      end

      it 'excludes matching datestamps if exclusive' do
        expect(mock_class.datestamp_before(today, exclusive: true))
          .to eq [mock_3]
      end
    end

    describe '.datestamp_after' do
      it 'returns records with a datestamp after or on the given date' do
        expect(mock_class.datestamp_after(today)).to eq [mock_1, mock_2]
      end

      it 'excludes matching datestamps if exclusive' do
        expect(mock_class.datestamp_after(today, exclusive: true))
          .to eq [mock_1]
      end
    end

    describe '.datestamp_between' do
      it 'returns records with a datestamp between the given dates' do
        expect(mock_class.datestamp_between(today - 4.days, today))
          .to eq [mock_2, mock_3]
      end

      it 'excludes matching beginning datestamps if exclusive' do
        expect(mock_class.datestamp_between(today - 2.days, today + 1.day, exclusive: true))
          .to eq [mock_2]
      end

      it 'excludes matching ending datestamps if exclusive' do
        expect(mock_class.datestamp_between(today - 4.days, today, exclusive: true))
          .to eq [mock_3]
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
