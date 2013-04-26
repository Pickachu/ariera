# -*- coding: utf-8 -*-
module Commands
  class Bought
    include Command::Commandable

    guards ['bought .+', 'comprei .+']
    parameter :entity

    help :syntax => 'comprei <produto>', :variants => [:comprei], :description => 'Guarda compra feita por você'

    handle do |m, params|
      r = m.reply

      entity = params[:entity]
                       
      unless entity.blank?
        product = Product.where(:name => entity[:name].downcase).first

        if product
          purchase = Purchase.new
          purchase.person = sender
          purchase.products << product

          if purchase.save
            "Compra de #{purchase.products.map(&:name).join(', ')} para #{sender.name} computada."
          else                                  
            "Erro ao criar compra! \n #{purchase.errors.full_messages.join("\n")}."
          end                                        
        else                                  
          "Produto #{entity[:name]} não encontrado."
        end                      
      else                      
        "Produto não informado."
      end         
    end
  end
end

# TODO Instantiate classes out of here
Commands::Bought.new
          
