module Queries
  class ListUpdate
    attr_reader :status, :establishment_id, :start_date, :end_date, :page

    class << self
      def with_filters(args)
        new args
      end
    end

    def initialize(args={})
      @status           = args[:status]
      @establishment_id = args[:establishment]
      @start_date       = args[:start_date]
      @end_date         = args[:end_date]
      @page             = args[:page]
    end

    def run
      updates = base_query
      updates = add_status updates
      updates = add_establishment updates
      updates = add_start_date updates
      updates = add_end_date updates
      updates = add_pagination updates
      updates = add_includes updates
      updates
    end

    private

    def add_status(updates)
      return updates unless status
      updates.where arel_table[:status].lower.eq status
    end

    def add_establishment(updates)
      return updates unless establishment_id
      updates.where establishment_id: establishment_id
    end

    def add_start_date(updates)
      return updates unless start_date
      updates.where arel_table[:created_at].gteq start_date
    end

    def add_end_date(updates)
      return updates unless end_date
      updates.where arel_table[:created_at].lteq end_date
    end

    def add_pagination(updates)
      return updates unless page
      updates.page(page)
    end

    def add_includes(updates)
      updates.includes :establishment
    end

    def start_date
      return unless @start_date
      Date.parse(@start_date).beginning_of_day
    end

    def end_date
      return unless @end_date
      Date.parse(@end_date).beginning_of_day
    end

    def arel_table
      ::ListUpdate.arel_table
    end

    def base_query
      ::ListUpdate.all
    end
  end
end
