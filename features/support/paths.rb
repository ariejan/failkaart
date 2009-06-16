module NavigationHelpers
  def path_to(page_name)
    case page_name
    
    when /the homepage/
      '/'
    else
      "/#{page_name}"
    end
  end
end

