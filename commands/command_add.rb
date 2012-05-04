# -*- coding: utf-8 -*-
class CommandAdd
  include Command

  def initialize
    @guards = ['adicionar .+', 'add .+']
    @parameters = [:type, :entity]

    listen
  end

  def help
    {:syntax => 'adicionar <entidade> <nome>', :variants => [:add, :adicionar], :description => 'Adiciona entidade'}
  end

  def execute m, params
    r = m.reply
    
    case params[:type][:name]
    when 'estabelecimento'
      food_establishment = FoodEstablishment.new
      food_establishment.name = params[:entity][:name]
      
      if food_establishment.save
        r.body = "Estabelecimento alimentício #{food_establishment.name} criado."
      else
        r.body = food_establishment.errors.full_messages.join "\n"
      end
    when 'pessoa'
      person = Person.new 
      person.name = params[:entity][:name]
      
      if person.save
        r.body = "Pessoa #{person.name} criada."
      else
        r.body = person.errors.full_messages.join "\n"
      end
    else
      r.body = "Entidade inexistente para adicionar: #{params[:entity][:name]}"
    end
    
    r
  end
end

# TODO Instantiate classes out of here
CommandAdd.new
