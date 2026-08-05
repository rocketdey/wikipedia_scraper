module TagScraper

  def self.scrape(element)
    return nil if element.nil? || element.classes.any? { |c| ['mw-cite-backlink', 'noprint'].include?(c) } || (!element.children.any? && element.text.empty?)
    case element.name
    when "p", "a", "i", "b", "br", "span"
      to_markdown(element)
    when "ol", "ul"
      parse_list(element)
    when "table"
      if !element.classes.include?('wikitable')
        if element.classes.include?('infobox')
          #return parse_infobox(element)
          return nil
        end

        element_list = element.css(".wikitable, .mw-heading")
        if element_list.empty?
          parse_table([element])
        elsif element_list.any? { |e| e.classes.include?('mw-heading')}
          content_list = []
          if element_list[0].classes.include?('wikitable')
            last_heading = nil
          else
            last_heading = element_list[0].at_css('h2, h3, h4').content
          end
          tables = []
          section = {heading: last_heading, content: tables}
          element_list.drop(1).each do |e|
            if e.classes.include?('mw-heading')
              section = {heading: last_heading, content: tables}
              content_list << section
              last_heading = e.at_css('h2, h3, h4').content
              tables = []
            else
              tables << parse_table([e])
            end
          end
          content_list
        else
          parse_table(element_list)
        end
      else
        parse_table([element])
      end
    when "div"
      if element.classes.include?('hatnote')
        to_markdown(element)
      else
        result = []
        text_inside_div = ''
        element.children.each do |child|
          if ["p", "a", "i", "b", "br", "span", "text"].include?(child.name)
            text_inside_div << (to_markdown(child) || '')
          else
            result << text_inside_div.strip && text_inside_div = '' unless text_inside_div.strip.empty?
            result << self.scrape(child)
          end
        end
        result << text_inside_div.strip unless text_inside_div.strip.empty?
        result.compact
      end
    when "style", "figure", "sup"
      nil
    else
      if !element.children.empty?
        element.children.map do |child|
          self.scrape(child)
        end.compact
      else
        to_markdown(element)
      end
    end
  end

  def self.to_markdown(element)

    unless element.nil? || element.classes.any? { |c| ['mw-cite-backlink', 'noprint'].include?(c) }
      case element.name
      when 'text'
        content = element.content.gsub(/\s+/, ' ')
        return content.strip.empty? ? nil : content
      when "ol", "ul"
        return parse_list(element).join(', ')
      end

      inner = element.children.map { |node| markdown_node(node) }.join
      inner = inner.gsub(/\s+/, ' ')
      inner = inner.strip unless inner == ' '

      case element.name
      when "b"
        "**#{inner}**"
      when "a"
        parse_anchor(element, inner)
      when "i"
        "*#{inner}*"
      else
        inner
      end
    end
  end

  def self.markdown_node(node)

    return '' if node.classes.any? { |c| ['mw-cite-backlink', 'noprint'].include?(c) }

    case node.name
    when "text"
      node.content
    when "br"
      ' '
    when "span"
      to_markdown(node)
    when "sup"
      return nil if node['style'] == "display:none;"
      node.at_css('a').nil? ? to_markdown(node) : parse_anchor(node.at_css('a'))
    when "style"
      nil
    else
      to_markdown(node)
    end
  end

  def self.parse_anchor(element, inner = nil)
    return nil if ['Wikipedia:Citation needed', 'Edit this at Wikidata'].include?(element['title'])

    url = element['href']
    if !inner.nil? && !inner.strip.empty?
      url_text = inner
    elsif element.content.empty?
      url_text = element['title']
    else
      url_text = element.content
    end

    if img = element.at_css('img')
      if img['alt'] || img['title']
        url_text = img['alt'] || img['title']
      else
        return '' if img['src']&.include?('/thumb/')
      end
    end

    if url.include?('&action=edit')
      "https://en.wikipedia.org#{url[18..]}"
    elsif url.include?('#cite_note')
      element.content
    elsif !url_text.nil? && !url_text.empty?
      url.include?('://') ? "[#{url_text}](#{url})".strip : "[#{url_text}](https://en.wikipedia.org#{url[18..]})".strip
    else
      url.include?('://') ? url : "https://en.wikipedia.org#{url[18..]}"
    end
  end

  def self.parse_list(element)
    items = []
    element.css('> li').each do |node|
      if reference_number = node['data-mw-footnote-number']
        items << "#{reference_number}. #{to_markdown(node)}"
      elsif node.matches?('.gallerybox')
        img_node = node.at_css('img')
        url = img_node.parent['href']
        if node.content.empty?
          items << [url.include?('://') ? url : "https://en.wikipedia.org#{url[18..]}", img_node['alt']]
        else
          items << [url.include?('://') ? url : "https://en.wikipedia.org#{url[18..]}", to_markdown(node.at_css(".gallerytext"))]
        end
      else
        items << to_markdown(node)
      end
    end

    items
  end

  def self.parse_table(element_list)
    main_tables = []
    element_list.each do |element|
      rows = element.css('tr')
      table_caption = to_markdown(element.at_css('caption'))
      table_caption = nil if table_caption&.empty?
      element.css('style').each(&:remove)
      col_length = rows[0].css('th:not([style*="display:none"])', 'td:not([style*="display:none"])').sum { |c| c['colspan'].nil? ? 1 : c['colspan'].to_i}
      table_data = Array.new(rows.length) { Array.new(col_length, nil) }
      rows.each_with_index do |row_element, row_index|
        unless row_element.css('table').empty?
          table_data = parse_table(row_element.css('table'))
          break
        end
        row = row_element.css('th:not([style*="display:none"])', 'td:not([style*="display:none"])')
        cursor_index = col_index = 0
        while col_index < row.length
          data = row[col_index]
          data_content = to_markdown(data)
          if data_content.is_a?(Array)
            table_data[row_index][cursor_index] << data_content
          elsif !table_data[row_index][cursor_index].nil?
            col_index += 1 if data_content.nil? || data_content.empty?
            cursor_index += 1
            break if cursor_index > col_length
            next
          else
            colspan = row[col_index]['colspan'].nil? ? 1 : row[col_index]['colspan'].to_i
            rowspan = row[col_index]['rowspan'].nil? ? 1 : row[col_index]['rowspan'].to_i
            (0..colspan - 1).each do |c|
              (0..rowspan - 1).each do |r|
                table_data[r + row_index][c + cursor_index] = data_content
              end
            end
          end
          cursor_index += colspan
          col_index += 1
        end
      end
      table_data.each do |row|
        row.map! { |a| a == '' ? nil : a} if row.is_a?(Array)
      end
      table_data.reject! { |a| a.all?(nil) || a.empty? }
      table_caption.nil? ? main_tables << table_data : main_tables << [table_caption] + table_data
    end
    main_tables.length > 1 ? main_tables : main_tables[0]
  end

  def self.parse_infobox(element)
    main_tables = []
    rows = element.css('tr')
    
    rows.each do |row|
      table_data = []
      label = row.at_css("th.infobox-label")
      if label
        row_dict = {label: to_markdown(label), content: []}
        combined_text = ''
        row.at_css('td').children.each do |row_elem|
          case row_elem.name
          when "p", "a", "i", "b", "br", "span", "text"
            combined_text << scrape(row_elem)
          else
            unless combined_text.empty?
              row_dict[:content][-1].nil? ? row_dict[:content] << combined_text : row_dict[:content][-1] << combined_text
            end
            combined_text = ''
            row_dict[:content].push(*scrape(row_elem))
          end
        end
        main_tables << row_dict
      else
        combined_text = ''
        row.at_css('td').children.each do |row_elem|
          puts combined_text
          case row_elem.name
          when "p", "a", "i", "b", "br", "span", "text"
            combined_text << scrape(row_elem)
          else
            unless combined_text.empty?
              table_data[-1].nil? ? table_data << combined_text : table_data[-1] << combined_text
            end
            combined_text = ''
            data = scrape(row_elem)
            data.is_a?(Array) ? table_data.push(*data) : table_data << data
          end
        end
      end
      main_tables << table_data
    end
    {id: nil, heading: 'Infobox', title: to_markdown(element.at_css('caption')), content: main_tables}
  end
end
