require_relative 'osia_helper'

j = get_json
categories = j['categories']
apps = j['projects']

def failed(message)
  warn "‼️  #{message}"
  exit 1
end

category_ids = osia_allowed_categories(categories)
duplicates = category_ids.tally.select { |_id, count| count > 1 }.keys
failed("duplicate category ids: #{duplicates.join(', ')}") unless duplicates.empty?

categories_by_id = categories.to_h { |category| [category['id'], category] }

categories.each do |category|
  parent_id = category['parent']
  next if parent_id.nil?

  failed("#{category['id']} has unknown parent #{parent_id}") unless categories_by_id.key? parent_id

  seen = { category['id'] => true }
  while parent_id
    failed("category cycle includes #{parent_id}") if seen[parent_id]

    seen[parent_id] = true
    parent_id = categories_by_id.fetch(parent_id)['parent']
  end
end

apps.each do |app|
  app_categories = app['category-ids']
  failed("#{app['title']} has no categories") unless app_categories.is_a?(Array) && !app_categories.empty?

  app_categories.each do |category_id|
    failed("#{category_id} is not a valid category for #{app['title']}") unless category_ids.include? category_id
  end
end

puts 'categories validated ✅'
