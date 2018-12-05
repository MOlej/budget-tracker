module ExpenditureHelper
  def sort(column, title = nil)
    title ||= column.titleize
    direction = (column == sort_column && sort_direction == 'asc') ? 'desc' : 'asc'
    icon = sort_direction == 'asc' ? '▲' : '▼'
    icon = column == sort_column ? icon : ''
    link_to "#{title}#{icon}", params.permit(:column, :direction, :search)
                                     .merge(column: column, direction: direction)
  end
end
