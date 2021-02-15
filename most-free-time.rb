require 'time'
require 'rspec'

def seconds_between_periods(start_period, end_period)
  start_period_end_time = start_period[1]
  end_period_start_time = end_period[0]
  end_period_start_time - start_period_end_time
end

def format_free_time(period_seconds)
  hours = (period_seconds / 3600).to_i
  minutes = ((period_seconds % 3600) / 60).to_i
  hours = "0#{hours}" if hours < 10
  minutes = "0#{minutes}" if minutes < 10
  "#{hours}:#{minutes}"
end

def find_longest_free_time(head, tail)
  return 0 if tail.empty?

  time_between_periods = seconds_between_periods(head, tail[0])
  next_head, *rest = tail
  next_free_time = find_longest_free_time(next_head, rest)
  time_between_periods > next_free_time ? time_between_periods : next_free_time
end

def parsed_time_periods(time_periods)
  time_periods.map do |period|
    start_and_end = period.split('-')

    start_and_end.map do |a_time|
      return nil if a_time.nil?

      Time.parse(a_time)
    end
  end
end

def sort_time_periods(time_periods)
  time_periods.sort do |a, b|
    if a[0] < b[0]
      -1
    elsif a[0] > b[0]
      1
    else
      0
    end
  end
end

def most_free_time(time_periods)
  free_time_formatted = '00:00'
  return free_time_formatted if time_periods.nil? || time_periods.empty? || time_periods.length <= 1

  periods = parsed_time_periods(time_periods)
  sorted_periods = sort_time_periods(periods)

  head, *tail = sorted_periods
  format_free_time(find_longest_free_time(head, tail))
end

describe 'most free time' do
  it 'returns free time between three unsorted time periods' do
    expected = '00:30'
    actual_free_time = most_free_time(['12:15PM-02:00PM', '09:00AM-10:00AM', '10:30AM-12:00PM'])
    expect(actual_free_time).to eq(expected)
  end

  it 'returns free time between two unsorted time periods' do
    expected = '02:15'
    actual_free_time = most_free_time(['12:15PM-02:00PM', '09:00AM-10:00AM'])
    expect(actual_free_time).to eq(expected)
  end

  it 'returns free time between three sorted time periods' do
    expected = '03:00'
    actual_free_time = most_free_time(['09:00AM-10:00AM', '12:15PM-02:00PM', '05:00PM-06:00PM'])
    expect(actual_free_time).to eq(expected)
  end

  it 'returns free time between two sorted time periods' do
    expected = '02:15'
    actual_free_time = most_free_time(['09:00AM-10:00AM', '12:15PM-02:00PM'])
    expect(actual_free_time).to eq(expected)
  end

  context 'free time should be zero' do
    expected_time = '00:00'

    it 'returns zero free time when time period is nil' do
      actual_free_time = most_free_time(nil)
      expect(actual_free_time).to eq(expected_time)
    end

    it 'returns zero free time when time period is invalid' do
      actual_free_time = most_free_time([''])
      expect(actual_free_time).to eq(expected_time)
    end

    it 'returns zero free time when time period start time is nil' do
      actual_free_time = most_free_time(['nil-02:00PM'])
      expect(actual_free_time).to eq(expected_time)
    end

    it 'returns zero free time when only one time period given' do
      actual_free_time = most_free_time(['12:15-02:00PM'])
      expect(actual_free_time).to eq(expected_time)
    end
  end
end
