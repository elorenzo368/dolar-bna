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
        dolar_buy, dolar_sell = set_dolar()
        if @conversion == "ars_to_usd"
          ars_to_dolar(dolar_sell)
        else
          dolar_to_ars(dolar_buy)
        end
      end

      private

      def set_dolar
        dolar_buy = 0
        dolar_sell = 0
        intents = 0
        while intents < 5
          dolar_query =  Dolar::Bna::DolarCotization.where(date: Date.today, dolar_type: @dolar_type).first
          if dolar_query.nil?
            intents += 1
            if @dolar_type.downcase == "divisa"
              Dolar::Bna::Exchange.new(Date.today).perform_bna_divisa
              dolar_query =  Dolar::Bna::DolarCotization.where(date: Date.today, dolar_type: @dolar_type).first
              dolar_buy = dolar_query.dolar_buy unless dolar_query.nil?
              dolar_sell = dolar_query.dolar_sell unless dolar_query.nil?
            elsif @dolar_type.downcase == "billete"
              Dolar::Bna::Exchange.new(Date.today).perform_bna_billete
              dolar_query =  Dolar::Bna::DolarCotization.where(date: Date.today, dolar_type: @dolar_type).first
              dolar_buy = dolar_query.dolar_buy unless dolar_query.nil?
              dolar_sell = dolar_query.dolar_sell unless dolar_query.nil?
            else
              dolar_buy = 0
              dolar_sell = dolar_query.dolar_sell unless dolar_query.nil?
              break
            end
          else
            dolar_buy = dolar_query.dolar_buy
            dolar_sell = dolar_query.dolar_sell unless dolar_query.nil?
            break
          end
        end
        return dolar_buy, dolar_sell
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
