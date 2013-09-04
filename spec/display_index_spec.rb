require_relative 'spec_helper'

describe DisplayIndex do
  subject {
    DisplayIndex.new(
      index: index,
      item_count: item_count,
      visible_line_count: visible_line_count,
      index_service: index_service
    )
  }

  let(:index) { 0 }
  let(:item_count) { 0 }
  let(:visible_line_count) { 0 }
  let(:index_service) { double 'index service', call: internal_index }
  let(:internal_index) { double 'internal index'}

  describe "initialization" do
    let(:any_positive_number) { 23 }

    it "should be initalised with an index of 0 if none is supplied" do
      expect(
        DisplayIndex.new(item_count: any_positive_number, visible_line_count: any_positive_number).index
      ).to eq 0
    end

    it "should be reject negative indices" do
      expect {
        DisplayIndex.new(
          index: -3,
          item_count: any_positive_number,
          visible_line_count: any_positive_number
        )
      }.to raise_error(ArgumentError)
    end

    it "should be reject negative values of visible_line_count" do
      expect {
        DisplayIndex.new(
          index: any_positive_number,
          item_count: any_positive_number,
          visible_line_count: -32
        )
      }.to raise_error(ArgumentError)
    end

    it "should be reject negative values of item_count" do
      expect {
        DisplayIndex.new(
          index: any_positive_number,
          item_count: -32,
          visible_line_count: any_positive_number
        )
      }.to raise_error(ArgumentError)
    end

    it "should reject out of bounds indices" do
      expect {
        DisplayIndex.new(
          index: 4,
          item_count: 10,
          visible_line_count: 10
        )
      }.to raise_error(ArgumentError)
    end

    it "should call index_service with index and max_index" do
      index = 1
      visible_line_count = 5
      item_count = 20

      index_service.should_receive(:call).with(index: 1, max_index: 15)

      DisplayIndex.new(
        index: index,
        item_count: item_count,
        visible_line_count: visible_line_count,
        index_service: index_service
      )
    end
  end

  describe "#max_index" do
    context "when visible_line_count > item_count" do
      let(:visible_line_count) { 11 }
      let(:item_count) { 10 }

      its(:max_index) { should eq 0 }
    end

    context "when visible_line_count = item_count" do
      let(:visible_line_count) { 10 }
      let(:item_count) { 10 }

      its(:max_index) { should eq 0 }
    end

    context "when visible_line_count < item_count" do
      let(:visible_line_count) { 5 }
      let(:item_count) { 10 }

      specify "its max_index should be the difference" do
        expect(subject.max_index).to eq 5
      end
    end
  end

  [:index, :move_up, :move_down].each do |method|
    it "should delegate #{method} to internal index" do
      internal_index.should_receive(method)
      subject.public_send(method)
    end
  end
end
