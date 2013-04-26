# -*- coding: utf-8 -*-
module Commands
  class Remove
    include Command::Commandable

    guards ['remover .+', 'remove .+', 'delete .+', 'del .+', 'deletar .+', 'rm .+']
    parameter :type
    parameter :entity
    parameter :filter

    help :syntax => 'remover <entidade> <nome>', :variants => [:remover, :remove, :deletar, :del, :rm], :description => 'Remove entidade especificada'

    handle do |m, params|
      r = m.reply

      case params[:type][:name]
      when 'purchase'
        purchase = Purchase.find params[:entity][:modifier]
        person = purchase.person
        products = purchase.products
        if purchase.destroy 
          r.body = "Compra de #{products.map(&:name).join(', ')} para #{person.nickname} deletada!"
        else
          r.body = "Erro ao remover compra"
        end
      when 'unhandled'
        unhandleds = Unhandled.all.length

        if Unhandled.destroy_all
          r.body = "#{unhandleds} mensagens não resolvidas deletadas"
        else
          r.body = "Erro ao remover mensagens não resolvidas"
        end
      else
        r.body = "Entidade inexistente ou remoção não implementada: #{params[:type][:name]}"
      end

      r
    end
  end
end

# TODO Instantiate classes out of here
Commands::Remove.new
