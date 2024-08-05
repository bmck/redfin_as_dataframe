require 'polars-df'
require 'httparty'
require 'zlib'
require 'stringio'
require 'csv'

module RedfinAsDataframe
  class National
    # Get data for the given name from the Bank of Canada.

    include ::HTTParty

    attr_reader :tag, :ary

    def initialize(series = nil, options={})
      @tag = series
    end

    def fetch(start: nil, fin: nil)
      dat = _fetch_data.dup
      hsh = dat.map!{|r| r.to_hash }
      keys = hsh.first.keys
      vals = hsh.map(&:values).transpose

      df = {}; (0..(keys.length-1)).to_a.each{|i| df[keys[i]] = vals[i]}

      df = Polars::DataFrame.new(df).drop(['period_duration', 'region_type', 'region_type_id','table_id','is_seasonally_adjusted','region','city','state','state_code', 'parent_metro_region', 'parent_metro_region_metro_code'])
      df = df.filter(Polars.col('period_end') <= fin.to_date) unless start.nil?
      df = df.filter(Polars.col('period_begin') >= start.to_date) unless fin.nil?
      s = Polars::Series.new('Timestamps', df['period_begin'].to_a)
      df = df.insert_column(0,s)

      df = (tag.nil? ? df : df.drop(df.columns - ['Timestamps', tag])).sort('Timestamps')
    end

    protected

    private

    def _fetch_data #(options={})
      if @ary.nil?
        tsv_gz = self.class.get('https://redfin-public-data.s3.us-west-2.amazonaws.com/redfin_market_tracker/us_national_market_tracker.tsv000.gz').parsed_response
        tsv = Zlib::GzipReader.new(StringIO.new(tsv_gz)).read    
        @ary = CSV.parse(tsv, headers: true, col_sep: "\t", converters: :numeric).select{|a| a['is_seasonally_adjusted'] == 'f'}.each{|r| r['period_begin'] = r['period_begin'].to_date; r['period_end'] = r['period_end'].to_date }
      end
      @ary
    end
  end
end
