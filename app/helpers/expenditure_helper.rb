module ExpenditureHelper
  def sort(column)
    direction = sort_direction_literal(column)
    icon = sort_icon(column)
    link_to "#{column.titleize}#{icon}", sorting_params(column, direction)
  end

  private

  def sort_direction_literal(column)
    column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
  end

  def sort_icon(column)
    return '' if column != sort_column

    sort_direction == 'asc' ? '▲' : '▼'
  end

  def sorting_params(column, direction)
    params.permit(:column, :direction, :search)
      .merge(column: column, direction: direction)
  end
end
