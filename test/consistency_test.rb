require "test_helper"

class SequenceTest < BaseTest
  def test_single_sequence_consistency
    n = 200

    n.times do |current|
      FirstSequencedModel.create
      assert_sequence_value "first_sequenced_model_auto_increment", current + 1
    end

    assert_equal FirstSequencedModel.only(:auto_increment).map(&:auto_increment).sort, (1..n).to_a
  end

  def test_id_sequence_consistency
    n = 200

    n.times do |current|
      IdSequencedModel.create
      assert_sequence_value "id_sequenced_model__id", current + 1
    end

    assert_equal IdSequencedModel.only(:id).map(&:id).sort, (1..n).to_a
  end

  def test_double_sequence_consistency
    n = 100

    n.times do |current|
      FirstSequencedModel.create
      assert_sequence_value "first_sequenced_model_auto_increment", current + 1
      SecondSequencedModel.create
      assert_sequence_value "second_sequenced_model_auto_increment", current + 1
    end

    assert_equal FirstSequencedModel.only(:auto_increment).map(&:auto_increment).sort, (1..n).to_a
    assert_equal SecondSequencedModel.only(:auto_increment).map(&:auto_increment).sort, (1..n).to_a
  end

  def test_prefix_sequence_consistency
    n = 100
    n.times do |current|
      PrefixSequencedModel.create(tenant_id: n)
      assert_sequence_value "prefix_sequenced_model_#{n}_auto_increment", current + 1
    end

    assert_equal PrefixSequencedModel.only(:auto_increment).map(&:auto_increment).sort, (1..n).to_a
  end
end
