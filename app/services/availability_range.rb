module AvailabilityRange
  FORMAT = '%l:%M %P'

  class << self
    def call(menu)
      start_time = menu.availability_start_time && menu.availability_start_time.strftime(FORMAT)
      end_time = menu.availability_end_time && menu.availability_end_time.strftime(FORMAT)
      if start_time
        [start_time, end_time].compact.map(&:strip).join(' - ')
      elsif end_time
        "until #{end_time}"
      else
        ''
      end
    end
  end
end
