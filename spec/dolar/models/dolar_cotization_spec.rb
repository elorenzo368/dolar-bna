RSpec.describe Dolar::Bna::DolarCotization, type: :model do
  context "when create DIVISA" do
    subject{create(:dolar_cotizations, dolar_type: 'Divisa')}
    it { should validate_presence_of(:date).with_message("Indicar fecha de la cotización") }
    it { should validate_presence_of(:dolar_type).with_message("Indicar tipo de cotización") }
    it { should validate_presence_of(:dolar_buy).with_message("Indicar cotización de compra") }
    it { should validate_presence_of(:dolar_sell).with_message("Indicar cotización de venta") }
    it { should validate_uniqueness_of(:date).scoped_to(:dolar_type).with_message("Ya existe una cotización de ese tipo para la fecha ingresada") }
    it { should validate_inclusion_of(:dolar_type).in_array(Dolar::Bna::DolarCotization::DOLAR_TYPES).with_message("Tipo de cotización inválido") }
    it { should validate_numericality_of(:dolar_buy).is_greater_than(0).with_message("La cotizacion debe ser mayor a 0") }
    it { should validate_numericality_of(:dolar_sell).is_greater_than(0).with_message("La cotizacion debe ser mayor a 0") }

  end

  context "when create BILLETE" do
    subject{create(:dolar_cotizations, dolar_type: 'Billete')}
    it { should validate_presence_of(:date).with_message("Indicar fecha de la cotización") }
    it { should validate_presence_of(:dolar_type).with_message("Indicar tipo de cotización") }
    it { should validate_presence_of(:dolar_buy).with_message("Indicar cotización de compra") }
    it { should validate_presence_of(:dolar_sell).with_message("Indicar cotización de venta") }
    it { should validate_uniqueness_of(:date).scoped_to(:dolar_type).with_message("Ya existe una cotización de ese tipo para la fecha ingresada") }
    it { should validate_inclusion_of(:dolar_type).in_array(Dolar::Bna::DolarCotization::DOLAR_TYPES).with_message("Tipo de cotización inválido") }

  end



end
