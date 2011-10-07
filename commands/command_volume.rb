# -*- coding: utf-8 -*-
class CommandVolume
  include Command

  def initialize
    @guards = ['volume(?:([+]|[-])|(?: ([\d]+))?)']
    @parameters = [:amount]
    listen
    @volume = volume
  end

  def permited? pessoa
    pessoa == 'Heitor'
  end

  def execute m, params
    # @todo Encapsular na classe command daqui
    puts 'executing volume'
    r = m.reply
    puts params.inspect

    modifier = params[:command][:modifier]
    amount = params[:amount]

    # até aqui

    if modifier == '+'
      unless volume >= 10 and not permited? params[:name] 
        self.volume = @volume + 1.0
      else
        r.body = "É uma pena, mais o volume máximo para você #{params[:name]} é 10."
        return r
      end
    elsif modifier == '-'
      self.volume = @volume - 1.0
    end
    
    if not amount.nil?
      amount = params[:amount][:modifier].to_f
      
      if (amount > 20)
        r.body = 'É uma pena, mais o volume máximo é 20.'
        return r;
      else
        if (amount > 10)
          r.body = "É uma pena, mais o volume máximo para você #{params[:name]} é 10."
          return r;
        end
      end
      self.volume = amount
    end

    r.body = bar()
    r
  end
  
  def bar()
    bar = '☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺'
    volume.to_i.times { bar.sub! '☺', '☻';} 
    bar
  end
  
  def volume=(value)
    value *= 7.0 / 20.0
    puts 'setting volume to ' + value.to_s
    `osascript -e "set Volume #{value}"`
    
    @volume = volume
  end
  
  def volume
    puts 'getting value of ' + `osascript -e "output volume of (get volume settings)"`
    `osascript -e "output volume of (get volume settings)"`.to_f * 20.0 / 100.0
  end
end

# TODO Instantiate classes out of here
CommandVolume.new
