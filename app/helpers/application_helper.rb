module ApplicationHelper

  # Present unseen rewards for the given user.
  #
  # options - A Hash of options:
  #           for: A rewardable model.
  #
  # Returns HTML.
  def present_rewards options
    rewardable = options[:for]
    rewards      = rewardable.rewards
    presentation = render partial: 'go_gamification/rewards/presentation', locals: { rewards: rewards }

    rewards.see

    presentation
  end

  def include_view_javascript
    js_path = Rails.root.join('app/assets/javascripts/views', params[:controller], "#{params[:action]}.*")
    return unless Dir[js_path].present?
    javascript_include_tag "views/#{params[:controller]}/#{params[:action]}"
  end

  def include_controller_javascript
    js_path = Rails.root.join('app/assets/javascripts/controllers', "#{params[:controller]}.*")
    return unless Dir[js_path].present?
    javascript_include_tag "controllers/#{params[:controller]}"
  end

  def show_by_file_type(attachment)
    if attachment.present?
      case File.extname(attachment.file.filename)
        when ".doc"
          link_to attachment.file.filename, attachment.url
        when ".docx"
          link_to attachment.file.filename, attachment.url
        when ".pdf"
          link_to attachment.file.filename, attachment.url
        when ".txt"
          link_to attachment.file.filename, attachment.url
        else
          image_tag attachment.thumb.url
      end
    else
      "Nenhum arquivo cadastrado."
    end
  end

  def url_with_protocol(url)
    /^http/i.match(url) ? url : "http://#{url}"
  end

  def flash_error_color(name)
    case name
      when 'success' then
        '#27ae60'
      when 'error' then
        '#ae5757'
      when 'alert' then
        '#edc613 '
      when 'notice' then
        '#27ae60'
      else
        name
    end
  end


  def flash_message_title(name)
    case name
      when 'success' then
        'Sucesso'
      when 'error' then
        'Atenção'
      when 'alert' then
        'Atenção '
      when 'notice' then
        'Atenção'
      else
        name
    end
  end

  def avatar_url(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      default_url = "#{root_url}images/guest.png"
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
    end
  end

  def link_to_image(image_path, target_link, options={})
    link_to(image_tag(image_path, border: "0", class: "image-size"), target_link, options)
  end

  def date_picker(form, field, label=nil, place_holder=nil, required=false, style=nil, disabled_plugin=false, valor_conteudo=nil, onchange=nil)
    style ||= "width: 120px;"
    valor = valor_conteudo if valor_conteudo
    valor = form.object.attributes[field.to_s].to_date.to_s_br if form.object.attributes[field.to_s] and valor_conteudo == nil
    # valor = form.object.attributes[field.to_s].to_date.to_s_br if form.object.attributes[field.to_s]
    form.text_field field, label: label, value: valor, placeholder: place_holder, data_required: required, class: "form-control input-lg data", "data-provide" => 'datepicker', "data-mask" => '99/99/9999', date_picker: "input-small date date-picker", html_icon: "<span class=\"input-group-btn\" style=\"vertical-align: top;\"><button class=\"btn btn-info\" type=\"button\"><i class=\"fa fa-calendar\"></i></button></span>", style: style, disable_plugin: disabled_plugin, onchange: onchange

  end


  class CodeRayify < Redcarpet::Render::HTML
    def block_code(code, language)
      CodeRay.scan(code, language).div
    end
  end

  def markdown(text)
    coderayified = CodeRayify.new(filter_html: true,
                                  hard_wrap: true)
    options = {
        fenced_code_blocks: true,
        no_intra_emphasis: true,
        autolink: true,
        lax_html_blocks: true,
    }
    markdown_to_html = Redcarpet::Markdown.new(coderayified, options)
    markdown_to_html.render(text).html_safe
  end

  def partners
    Partner.all.count
  end

  def get_github_user(user)
    social_network = user.social_networks.where("link like '%github%'").first
    social_network != nil ? social_network.link.split('/')[-1] : nil
  end

  # params:
  #   ext - file extension
  # ==== Examples
  # lines_of_code(rb)
  # lines_of_code(html)
  # Returns a number of lines of codes based on parameter
  def lines_of_code(ext)


    o = 0 # Number of files
    n = 0 # Number of lines of code
    m = 0 # Number of lines of comments

    files = Dir.glob('./**/*.' + ext)

    files.each do |f|
      next if f.index('vendor')
      next if FileTest.directory?(f)
      o += 1
      i = 0
      File.new(f).each_line do |line|
        if line.strip[0] == '#'
          m += 1
          next
        end
        i += 1
      end
      n += i
    end

    puts "#{o.to_s} files."
    puts "#{n.to_s} lines of code."
    puts "#{(n.to_f/o.to_f).round(2)} LOC/file."
    puts "#{m.to_s} lines of comments."
    return n
  end
  # Returns number of registrated users
  def users_ammount
    return User.all.size
  end

  def converte_date(date)
    date.to_date.to_s_br if date
  end

  def yes_no(bool)
    bool ? "Sim" : 'Não'
  end

  def truncate_with_hover(text, length = 30)
    "#{truncate(text, length: length)}".html_safe if !text.blank?
  end

  def date_range_picker_tag(campo_inicio, campo_final, label, valor_inicio = nil, valor_final = nil, required = false, bootstrapform = true, customize = nil)
    conteudo = "<div class='form-group' data_required='#{required}'>"
    conteudo += "<label class='control-label'>#{label}</label>" if label
    conteudo += "<div class='input-group input-small'>
       #{text_field_tag campo_inicio, valor_inicio, :class => 'form-control input-small datepicker date-picker',:style => 'border-top-left-radius: 4px; border-bottom-left-radius: 4px;', :disable_plugin => true}
          <span class='input-group-addon date-range-picker'>até</span>
      #{text_field_tag campo_final, valor_final, :class => 'form-control input-small datepicker date-picker', :style => 'border-top-right-radius: 4px; border-bottom-right-radius: 4px;', :disable_plugin => true}
      </div>
  </div>"
    conteudo.html_safe


  end

  def active_inactive(value)
    value ? "Ativo" : "Inativo"
  end

end

