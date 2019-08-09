module Dolar
  module Bna
    class Convert
      def initialize(value=0, conversion="ars_to_dolar", dolar_type="Divisa")
        @value ||= value
        @conversion ||= conversion
        @dolar_type ||= dolar_type
      end

      def perform
        dolar_query =  Dolar::Bna::DolarCotization.where(date: Date.today, dolar_type: @dolar_type).first
        dolar_buy = dolar_query.nil? ? nil : dolar_query.dolar_buy
        if @conversion == "ars_to_dolar"
          ars_to_dolar(dolar_buy)
        else
          dolar_to_ars(dolar_buy)
        end
      end

      private

      def ars_to_dolar dolar_buy
        valor = if !dolar_buy.nil?
          @value.to_f / dolar_buy.to_f
        else
          0
        end
        return valor.round(2)
      end

      def dolar_to_ars dolar_buy
        valor = if !dolar_buy.nil?
          @value.to_f * dolar_buy.to_f
        else
          0
        end
        return valor.round(2)
      end
    end
  end
end
