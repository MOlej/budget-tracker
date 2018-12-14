module DeviseHelper
  def devise_error_messages!
    return "" unless devise_error_messages?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    errors_count = resource.errors.count

    html = <<-HTML
      <div class="alert alert-danger col-4">
        <div id="error_explanation">
          <h5 class="alert-heading">#{pluralize(errors_count, 'error')}:</h5>
          <ul>#{messages}</ul>
        </div>
      </div>
    HTML

    html.html_safe
  end

  def devise_error_messages?
    !resource.errors.empty?
  end

end
