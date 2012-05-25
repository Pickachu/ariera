require_relative '../spec_helper'

class DummyClass; end;

describe Command do
  before(:each) do
    @command = DummyClass.new
    @command.extend Command
  end

  describe 'when receive body with name in brackets' do
    let(:body) {'[domo] uma mensagem aleatoria'}
         
    it 'should extract the person name' do
      expect {
        @command.extract_person_name(body).should
      }.to change {@command.params}.from([]).to(['domo'])
    end                                  

  end

end
