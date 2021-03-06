module ItemsHelper
  include Pagy::Frontend

  def item_categories(item)
    item.categories.map(&:name).sort.join(", ")
  end

  def item_status_options
    explainations = {
      "pending" => "just acquired; not ready to loan",
      "active" => "available to loan",
      "maintenance" => "needs repair; do not loan",
      "retired" => "no longer part of our inventory"
    }
    Item.statuses.map do |key, value|
      ["#{key.titleize} (#{explainations[key]})", key]
    end
  end

  def borrow_policy_options
    BorrowPolicy.alpha_by_code.map do |borrow_policy|
      ["(#{borrow_policy.code}) #{borrow_policy.name}: #{borrow_policy.description}", borrow_policy.id]
    end
  end

  def category_nav(categories, current_category = nil)
    return unless categories

    tag.div class: "nav tag-nav" do
      categories.map { |category|
        tag.li(class: "nav-item #{"active" if category.id == current_category&.id}") {
          "&nbsp;&nbsp;".html_safe * category.path_ids.size + link_to(category.name, category: category.id)
        }
      }.join.html_safe
    end
  end

  def rotated_variant(image, options = {})
    if image.metadata.key? "rotation"
      options[:rotate] ||= image.metadata["rotation"]
    end
    image.variant(options)
  end

  def full_item_number(item)
    item.complete_number
  end

  def item_status_label(item)
    class_name, label = if item.active?
      if item.checked_out_exclusive_loan
        ["label-primary", "Checked Out"]
      elsif item.holds.active.count > 0
        ["label-warning", "On Hold"]
      else
        ["label-success", "Available"]
      end
    else
      ["", "Unavailable"]
    end
    tag.span label, class: "label item-checkout-status #{class_name}"
  end

  def loan_description(loan)
    link = link_to preferred_or_default_name(loan.member), [:admin, loan.member]
    "Currently on loan to ".html_safe + link + "."
  end
end
