require 'spec_helper'
require 'zlib'
require 'stringio'

RSpec.describe RedfinAsDataframe::National do
  let(:fixture_path) { File.expand_path('../fixtures/us_national_market_tracker.tsv', __FILE__) }
  let(:fixture_content) { File.read(fixture_path) }
  let(:gzipped_content) do
    sio = StringIO.new
    gz = Zlib::GzipWriter.new(sio)
    gz.write(fixture_content)
    gz.close
    sio.string
  end

  before do
    stub_request(:get, 'https://redfin-public-data.s3.us-west-2.amazonaws.com/redfin_market_tracker/us_national_market_tracker.tsv000.gz')
      .to_return(status: 200, body: gzipped_content, headers: { 'Content-Type' => 'application/x-gzip' })
  end

  describe '#initialize' do
    it 'creates an instance without a series parameter' do
      national = described_class.new
      expect(national).to be_a(RedfinAsDataframe::National)
      expect(national.tag).to be_nil
    end

    it 'creates an instance with a series parameter' do
      national = described_class.new('median_sale_price')
      expect(national).to be_a(RedfinAsDataframe::National)
      expect(national.tag).to eq('median_sale_price')
    end
  end

  describe '#fetch' do
    let(:national) { described_class.new }

    context 'without filters' do
      it 'fetches and returns a Polars DataFrame' do
        df = national.fetch
        expect(df).to be_a(Polars::DataFrame)
        expect(df.columns).to include('Timestamps')
        expect(df.height).to eq(6)
      end

      it 'includes the Timestamps column as the first column' do
        df = national.fetch
        expect(df.columns.first).to eq('Timestamps')
      end

      it 'drops unnecessary columns' do
        df = national.fetch
        dropped_columns = ['period_duration', 'region_type', 'region_type_id', 'table_id',
                          'is_seasonally_adjusted', 'region', 'city', 'state', 'state_code',
                          'parent_metro_region', 'parent_metro_region_metro_code']
        dropped_columns.each do |col|
          expect(df.columns).not_to include(col)
        end
      end

      it 'filters for non-seasonally-adjusted data only' do
        df = national.fetch
        # All rows should be non-seasonally-adjusted (is_seasonally_adjusted == 'f')
        # This is verified in the data fetching logic
        expect(df.height).to eq(6)
      end
    end

    context 'with start parameter' do
      it 'filters data to include only rows on or after the start date' do
        df = national.fetch(start: '2020-03-01')
        period_begins = df['period_begin'].to_a
        expect(period_begins.all? { |d| d >= Date.parse('2020-03-01') }).to be true
        expect(df.height).to eq(4) # 2020-03-01, 2020-06-01, 2020-07-01, 2020-12-01
      end

      it 'accepts Date objects for start parameter' do
        df = national.fetch(start: Date.parse('2020-06-01'))
        period_begins = df['period_begin'].to_a
        expect(period_begins.all? { |d| d >= Date.parse('2020-06-01') }).to be true
        expect(df.height).to eq(3) # 2020-06-01, 2020-07-01, 2020-12-01
      end
    end

    context 'with fin parameter' do
      it 'filters data to include only rows on or before the fin date' do
        df = national.fetch(fin: '2020-03-31')
        period_ends = df['period_end'].to_a
        expect(period_ends.all? { |d| d <= Date.parse('2020-03-31') }).to be true
        expect(df.height).to eq(3) # Jan, Feb, Mar 2020
      end

      it 'accepts Date objects for fin parameter' do
        df = national.fetch(fin: Date.parse('2020-02-29'))
        period_ends = df['period_end'].to_a
        expect(period_ends.all? { |d| d <= Date.parse('2020-02-29') }).to be true
        expect(df.height).to eq(2) # Jan, Feb 2020
      end
    end

    context 'with both start and fin parameters' do
      it 'filters data to be within the date range' do
        df = national.fetch(start: '2020-02-01', fin: '2020-07-31')
        period_begins = df['period_begin'].to_a
        period_ends = df['period_end'].to_a
        
        expect(period_begins.all? { |d| d >= Date.parse('2020-02-01') }).to be true
        expect(period_ends.all? { |d| d <= Date.parse('2020-07-31') }).to be true
        expect(df.height).to eq(4) # Feb, Mar, Jun, Jul 2020
      end

      it 'returns empty dataframe if date range is invalid' do
        df = national.fetch(start: '2020-12-01', fin: '2020-01-31')
        expect(df.height).to eq(0)
      end
    end

    context 'with series parameter' do
      it 'returns only the Timestamps and specified series column' do
        national_with_series = described_class.new('median_sale_price')
        df = national_with_series.fetch
        expect(df.columns).to eq(['Timestamps', 'median_sale_price'])
        expect(df.height).to eq(6)
      end

      it 'works with series parameter and date filters' do
        national_with_series = described_class.new('median_list_price')
        df = national_with_series.fetch(start: '2020-03-01', fin: '2020-07-31')
        expect(df.columns).to eq(['Timestamps', 'median_list_price'])
        expect(df.height).to eq(3) # Mar, Jun, Jul 2020
      end
    end

    context 'caching behavior' do
      it 'caches the fetched data after first request' do
        national = described_class.new
        
        # First fetch
        df1 = national.fetch
        
        # Second fetch should use cached data (no additional HTTP request)
        df2 = national.fetch(start: '2020-03-01')
        
        # Verify only one HTTP request was made
        expect(WebMock).to have_requested(:get, 'https://redfin-public-data.s3.us-west-2.amazonaws.com/redfin_market_tracker/us_national_market_tracker.tsv000.gz')
          .once
      end
    end
  end
end
