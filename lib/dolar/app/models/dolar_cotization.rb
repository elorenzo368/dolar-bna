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
      #validates_uniqueness_of :date, scope: [:dolar_type, :dolar_sell], if: :message: 'Ya existe una cotización de ese tipo para la fecha ingresada'
      DOLAR_TYPES = ["Divisa", "Billete", "Blue"]

      validates_inclusion_of :dolar_type, in: DOLAR_TYPES, message: 'Tipo de cotización inválido'

      def self.search_by_date_range search
        unless search.blank?
          # La fecha la pasa un daterangepicker que la envia en este formato '01/01/2023 - 31/12/2023' 
          first_date, last_date = search.split(" - ")
          where(date: first_date .. last_date)
        else
          all
        end
      end

      def self.search_by_date search
        unless search.blank?
          where(date: search)
        else
          all
        end
      end

      def self.search_by_dolar_type search
        unless search.blank?
          where(dolar_type: search)
        else
          all
        end
      end

    end

  end
end
