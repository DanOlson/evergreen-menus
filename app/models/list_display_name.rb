class ListDisplayName
  def initialize(list)
    @list = list
  end

  def to_str
    metadata.fetch('display_name') { @list.name }
  end
  alias_method :to_s, :to_str

  def inspect
    "#<ListDisplayName:#{to_str}>"
  end

  private

  def metadata
    @list.respond_to?(:list_item_metadata) ? @list.list_item_metadata : {}
  end
end
