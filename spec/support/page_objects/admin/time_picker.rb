require 'site_prism'

module PageObjects
  module Admin
    class TimePicker < SitePrism::Section
      element :hours_list, '.rc-time-picker-panel-select:nth-child(1)'
      element :minutes_list, '.rc-time-picker-panel-select:nth-child(2)'
      element :meridiem_list, '.rc-time-picker-panel-select:nth-child(3)'

      def hour=(hour)
        hours_list.find('li', text: hour).click
      end

      def minute=(minute)
        minutes_list.find('li', text: minute).click
      end

      def meridiem=(meridiem)
        meridiem_list.find('li', text: meridiem).click
      end
    end
  end
end
