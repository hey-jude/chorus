module Admin
  module LicensesHelper

    def progress_bar(options = {})
      min = options[:min] || 0
      max = options[:max] || 100
      value = options[:value] || 0
      context = options[:context] || "success"

      percentage = (value / max.to_f) * 100

      html = <<-HEREDOC
      <div class="progress">
        <div class="progress-bar progress-bar-#{context}" role="progressbar" aria-valuenow="#{value}" aria-valuemin="#{min}" aria-valuemax="#{max}" style="width: #{percentage}%">
          #{value} / #{max}
        </div>
      </div>
      HEREDOC

      html.html_safe
    end
  end
end