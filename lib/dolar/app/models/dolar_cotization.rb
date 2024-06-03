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
      DOLAR_TYPES = ["Divisa", "Billete", "Blue", "MEP", "CCL", "Tarjeta", "Agro"]

      validates_inclusion_of :dolar_type, in: DOLAR_TYPES, message: 'Tipo de cotización inválido'

      after_save :set_dolar_agro, if: :dolar_agro_changer?

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

      def dolar_agro_changer?
        dolar_type == 'MEP' || dolar_type == 'Divisa'
      end

      def set_dolar_agro
        first_dolar_multiplier = (dolar_type == 'MEP' ? 0.2 : 0.8)
        second_dolar_multiplier = (dolar_type == 'MEP' ? 0.8 : 0.2)
        other_dolar_to_calc = Dolar::Bna::DolarCotization.where(dolar_type: dolar_type == 'MEP' ? 'Divisa' : 'MEP', date: self.date).order(date: :asc, created_at: :asc).last
        if other_dolar_to_calc
          dolar_buy_average = ((self.dolar_buy.to_f * first_dolar_multiplier) + (other_dolar_to_calc.dolar_buy.to_f * second_dolar_multiplier)).round(2)
          dolar_sell_average = ((self.dolar_sell.to_f * first_dolar_multiplier) + (other_dolar_to_calc.dolar_sell.to_f * second_dolar_multiplier)).round(2)
          Dolar::Bna::DolarCotization.where(dolar_type: 'Agro', dolar_buy: dolar_buy_average, dolar_sell: dolar_sell_average, date: self.date).first_or_create
        end
      end
    end
  end
end
