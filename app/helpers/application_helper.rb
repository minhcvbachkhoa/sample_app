module ApplicationHelper
  def full_title title
    title.empty? ? t("rort") : title + " | " + t("rort")
  end
end
