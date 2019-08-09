RSpec.describe Dolar::Bna::Exchange do
  it "divisa_request_has_not_result" do
    expect(Dolar::Bna::Exchange.new(Date.today).perform_bna_divisa).not_to be nil
  end

  it "billete_request_has_not_result" do
    expect(Dolar::Bna::Exchange.new(Date.today).perform_bna_billete).not_to be nil
  end

end
