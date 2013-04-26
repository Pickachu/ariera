# -*- coding: utf-8 -*-
module Commands
  class Add
    include Command::Commandable

    guards ['adicionar .+', 'add .+', 'criar .+']

    parameter :type
    parameter :entity
    parameter :other

    help :syntax => 'adicionar <entidade> <nome> <outros...>', :variants => [:add, :adicionar, :criar], :description => 'Adiciona entidade'


    handle do |m, params|
      r = m.reply

      supported_entities = ['estabelecimento', 'pessoa', 'produto', 'refrigerante']
                                                      
      case params[:type][:name]
      when 'refrigerante'
        product = Product.new
        product.name = params[:entity][:name].downcase
        product.kind = :refrigerante
        
        if product.save
          r.body = "Refrigerante #{product.name.capitalize} criado."
        else                  
          r.body = product.errors.full_messages.join "\n"
        end        
        
      when 'product', 'produto'
        next "Parametro tipo é obrigatório: <br /> adicionar produto #{params[:entity][:name]} refrigerante" if params[:other].nil?

        product = Product.new
        product.name = params[:entity][:name].downcase
        product.kind = params[:other][:name].downcase
                                                        
        if product.save
          r.body = "Produto #{product.name.capitalize} criado."
        else                  
          r.body = product.errors.full_messages.join "\n"
        end        
        
      when 'estabelecimento'
        food_establishment = FoodEstablishment.new
        food_establishment.name = params[:entity][:name]

        if food_establishment.save
          r.body = "Estabelecimento alimentício #{food_establishment.name} criado."
        else
          r.body = food_establishment.errors.full_messages.join "\n"
        end
      when 'pessoa', 'person'
        person = Person.new
        person.name = params[:entity][:name]

        if person.save
          r.body = "Pessoa #{person.name} criada."
        else
          r.body = person.errors.full_messages.join "\n"
        end
      else
        unless params[:entity].blank?
          r.body = "Entidade inexistente para adicionar: #{params[:entity][:name]}\n"
          r.body += "Entidades existentes: #{supported_entities.join(', ')}"
        else
          r.body = "Entidade não informada"
        end
      end


      r
    end
  end
end

# TODO Instantiate classes out of here
Commands::Add.new
