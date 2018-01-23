require_relative '../time_picker'

module PageObjects
  module Admin
    module AvailabilityRestrictable
      class << self
        def included(base)
          base.class_eval do
            section :time_picker, TimePicker, '.rc-time-picker-panel'
          end
        end
      end

      def restrict_availability=(state)
        restrict_availability_input.set state
      end

      def has_restricted_availability?
        restrict_availability_input.checked?
      end

      def availability_start=(hour:, minute:, meridiem:)
        availability_start_time_input.click
        time_picker.hour = hour
        time_picker.minute = minute
        time_picker.meridiem = meridiem
        find('[data-test="time-picker-label"]', text: 'Availability Start').click
      end

      def availability_end=(hour:, minute:, meridiem:)
        availability_end_time_input.click
        time_picker.hour = hour
        time_picker.minute = minute
        time_picker.meridiem = meridiem
        find('[data-test="time-picker-label"]', text: 'Availability End').click
      end

      def availability_start
        availability_start_time_input.value
      end

      def availability_end
        availability_end_time_input.value
      end
    end
  end
end
