require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../lib/active_recordless'

describe 'ActiveRecordless' do
  before(:each) do
    @conn = ActiveRecord::Base.connection
    class << @conn
      attr_accessor :mock
      def execute
        mock.execute
      end
    end

    @mock = mock("ActiveRecord") do |m|
      m.should_receive(:execute).never
    end
    @conn.mock = @mock

    @ar_class = Class.new(ActiveRecord::Base)
  end

  it "should have tests"
  
  it "should stub out new"
  it "should stub out find"
  it "should stub out create"
  it "should warn on find_by_sql"
  it "should stub out columns" do
    ActiveRecord::Base.disconnect!
    @ar_class.columns.should == []
  end

  it "should only work if disconnect is called" do
    lambda { @ar_class.columns }.should raise_error
  end
  it "should stub out associations"
end
