module Dolar
  module Bna
    class DolarCotization < ActiveRecord::Base
      self.table_name = "dolar_cotizations"
      validates_presence_of :date, message: 'Indicar fecha de la cotización'
      validates_presence_of :dolar_type, message: 'Indicar tipo de cotizacion'
      validates_presence_of :dolar_buy, message: 'Indicar cotizacion de compra'
      validates_presence_of :dolar_sell, message: 'Indicar cotizacion de venta'
      validates_numericality_of :dolar_buy, greater_than: 0, message: 'La cotizacion debe ser mayor a 0'
      validates_numericality_of :dolar_sell, greater_than: 0, message: 'La cotizacion debe ser mayor a 0'
      validates_uniqueness_of :date, scope: [:dolar_type, :dolar_sell], message: 'Ya existe una cotización de ese tipo para la fecha ingresada'
      DOLAR_TYPES = ["Divisa", "Billete"]

      validates_inclusion_of :dolar_type, in: DOLAR_TYPES, message: 'Tipo de cotización inválido'


    end

  end
end
