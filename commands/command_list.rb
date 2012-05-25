# -*- coding: utf-8 -*-
class Commands::List
  include Command::Commandable

  guards ['list .+', 'listar .+']
  parameter :entity
  parameter :pagina

  def listables
    tables = Mongoid::Config.master.collection_names
    tables.map {|table| table.singularize}
  end

  def listable? entity
    listables.include? entity
  end

  handle do |m, params|
    r = m.reply
    
    pagina = params[:pagina] || {:modifier => 0}
    pagina = pagina[:modifier].to_i

    unless params[:entity].nil?
      entity = params[:entity][:name].singularize
      if listable? entity
        list = entity.camelize.constantize.limit(10).offset(10 * pagina).all
        
        if list.any?
          names = list.first.attributes.map(&:first)
          line_format = names.map {|name| name + ': %-10s'}.join(' ') + "\n"
          
          #line_format = '%10s ' * list.first.attributes.length + "\n"
          
          response = "== List of #{entity.capitalize.pluralize} #{10 * pagina} - #{10 * (pagina + 1)}\n"
          #response += format *([line_format] + list.first.attributes.map(&:first)) 
          list.each do |item|
            response += format *([line_format] + item.attributes.map(&:second))
          end
          
          r.body = response
        else
          r.body = "Nenhuma #{entity.downcase} para os parametros pedidos."
        end
      else
        r.body = "Você precisa informar qual entidade quer listar: \n"
        r.body += listables.join ', '
      end
    end
    
    r
  end

  def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
    if first_letter_in_uppercase
      lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    else
      lower_case_and_underscored_word.to_s[0].chr.downcase + camelize(lower_case_and_underscored_word)[1..-1]
    end
  end

  def constantize(camel_cased_word)
    names = camel_cased_word.split('::')
    names.shift if names.empty? || names.first.empty?
    
    constant = Object
    names.each do |name|
      constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
    end
    constant
  end
end

# TODO Instantiate classes out of here
Commands::List.new
