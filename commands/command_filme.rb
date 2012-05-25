class Commands::Filme
  include Command::Commandable

  guards ['cinema .+', 'filmes .+']
  
  handle do |message, params|
    'Commando de gerenciamento de filmes nao implementado'
  end
end

Commands::Filme
