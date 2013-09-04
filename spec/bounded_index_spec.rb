require_relative 'spec_helper'

describe BoundedIndex do
  subject { BoundedIndex.new(index: index, max_index: max_index) }

  describe "initialization" do
    let(:any_positive_number) { 23 }

    it "should be initalised with an index of 0 if none is supplied" do
      expect(
        BoundedIndex.new(max_index: any_positive_number).index
      ).to eq 0
    end

    it "should be reject negative indices" do
      expect {
        BoundedIndex.new(index: -3, max_index: any_positive_number)
      }.to raise_error(ArgumentError)
    end

    it "should be reject negative values of max_index" do
      expect {
        BoundedIndex.new(index: any_positive_number, max_index: -43)
      }.to raise_error(ArgumentError)
    end

    it "should reject out of bounds indices" do
      expect {
        BoundedIndex.new(index: 30, max_index: 10)
      }.to raise_error(ArgumentError)
    end
  end

  describe "index methods" do
    let(:max_index) { 9 }

    describe '#move_up' do
      before(:each) do
        subject.move_up
      end

      context 'when at list start' do
        let(:index) {0}
        it 'should have the same index' do
          subject.index.should == 0
        end
      end

      let(:index) {9}
      it 'should decrease its index by one' do
        subject.index.should == 8
      end
    end

    describe '#move_down' do
      before(:each) do
        subject.move_down
      end

      context 'when at list end' do
        let(:index) {9}
        it 'should have the same index' do
          subject.index.should == 9
        end
      end

      let(:index) {1}
      it 'should increase its index by one' do
        subject.index.should == 2
      end
    end
  end
end
