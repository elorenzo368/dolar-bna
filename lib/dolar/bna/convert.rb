module Dolar
  module Bna
    class Convert
      def initialize(value=0, conversion="ars_to_usd", dolar_type="Divisa")
        @value ||= value
        @conversion ||= conversion
        @dolar_type ||= dolar_type
      end

      def perform
        #dolar_query =  Dolar::Bna::DolarCotization.where(date: Date.today, dolar_type: @dolar_type).first
        dolar_buy = set_dolar_buy()
        if @conversion == "ars_to_usd"
          ars_to_dolar(dolar_buy)
        else
          dolar_to_ars(dolar_buy)
        end
      end

      private

      def set_dolar_buy
        dolar_buy = nil
        while dolar_buy.nil?
          dolar_query =  Dolar::Bna::DolarCotization.where(date: Date.today, dolar_type: @dolar_type).first
          if dolar_query.nil?
            if @dolar_type.downcase == "divisa"
              Dolar::Bna::Exchange.new(Date.today).perform_bna_divisa
              dolar_query =  Dolar::Bna::DolarCotization.where(date: Date.today, dolar_type: @dolar_type).first
              dolar_buy = dolar_query.dolar_buy
            elsif @dolar_type.downcase == "billete"
              Dolar::Bna::Exchange.new(Date.today).perform_bna_billete
              dolar_query =  Dolar::Bna::DolarCotization.where(date: Date.today, dolar_type: @dolar_type).first
              dolar_buy = dolar_query.dolar_buy
            else
              dolar_buy = nil
              break
            end
          else
            dolar_buy = dolar_query.dolar_buy
          end
        end
        return dolar_buy
      end

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
