module ExpenditureHelper
  def sort(column, title = nil)
    title ||= column.titleize
    direction = sort_direction_literal(column)
    icon = sort_icon(column)
    link_to "#{title}#{icon}", sorting_params(column, direction)
  end

  private

  def sort_direction_literal(column)
    column == params[:column] && sort_direction == 'asc' ? 'desc' : 'asc'
  end

  def sort_icon(column)
    return '' if column != params[:column]

    sort_direction == 'asc' ? '▲' : '▼'
  end

  def sorting_params(column, direction)
    params.permit(:column, :direction, :search)
      .merge(column: column, direction: direction)
  end
end
