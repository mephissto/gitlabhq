require 'rails_helper'

describe List do
  describe 'relationships' do
    it { is_expected.to belong_to(:board) }
    it { is_expected.to belong_to(:label) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:board) }
    it { is_expected.to validate_presence_of(:label) }
    it { is_expected.to validate_presence_of(:list_type) }
    it { is_expected.to validate_presence_of(:position) }
    it { is_expected.to validate_numericality_of(:position).only_integer.is_greater_than_or_equal_to(0) }

    it 'validates uniqueness of label scoped to board_id' do
      create(:list)

      expect(subject).to validate_uniqueness_of(:label_id).scoped_to(:board_id)
    end

    context 'when list_type is set to backlog' do
      subject { described_class.new(list_type: :backlog) }

      it { is_expected.not_to validate_presence_of(:label) }
      it { is_expected.not_to validate_presence_of(:position) }
    end

    context 'when list_type is set to done' do
      subject { described_class.new(list_type: :done) }

      it { is_expected.not_to validate_presence_of(:label) }
      it { is_expected.not_to validate_presence_of(:position) }
    end
  end

  describe '#destroy' do
    it 'can be destroyed when when list_type is set to label' do
      subject = create(:list)

      expect(subject.destroy).to be_truthy
    end

    it 'can not be destroyed when list_type is set to backlog' do
      subject = create(:backlog_list)

      expect(subject.destroy).to be_falsey
    end

    it 'can not be destroyed when when list_type is set to done' do
      subject = create(:done_list)

      expect(subject.destroy).to be_falsey
    end
  end

  describe '#title' do
    it 'returns label name when list_type is set to label' do
      subject.list_type = :label
      subject.label = Label.new(name: 'Development')

      expect(subject.title).to eq 'Development'
    end

    it 'returns Backlog when list_type is set to backlog' do
      subject.list_type = :backlog

      expect(subject.title).to eq 'Backlog'
    end

    it 'returns Done when list_type is set to done' do
      subject.list_type = :done

      expect(subject.title).to eq 'Done'
    end
  end
end
