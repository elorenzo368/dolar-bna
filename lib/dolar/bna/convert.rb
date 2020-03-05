module Dolar
  module Bna
    class Convert
      def initialize(value=0, conversion="ars_to_usd", dolar_type="Divisa", date=Date.today, aliquot=0)
        @value ||= value
        @conversion ||= conversion
        @dolar_type ||= dolar_type
        @date ||= date
        @aliquot ||= aliquot
      end

      def perform
        #dolar_query =  Dolar::Bna::DolarCotization.where(date: Date.today, dolar_type: @dolar_type).first
        dolar_buy, dolar_sell = set_dolar(@date)
        if @conversion == "ars_to_usd"
          ars_to_dolar(dolar_sell)
        else
          dolar_to_ars(dolar_buy)
        end
      end

      private

      def set_dolar date
        dolar_buy = 0
        dolar_sell = 0
        intents = 0
        date = date.to_date
        while intents < 5
          dolar_query =  Dolar::Bna::DolarCotization.where(date: date, dolar_type: @dolar_type).first
          if dolar_query.blank?
            intents += 1
            if @dolar_type.downcase == "divisa"
              Dolar::Bna::Exchange.new(date).perform_bna_divisa
              dolar_query =  Dolar::Bna::DolarCotization.where(date: date, dolar_type: @dolar_type).first
              dolar_buy = dolar_query.dolar_buy unless dolar_query.blank?
              dolar_sell = dolar_query.dolar_sell unless dolar_query.blank?
            elsif @dolar_type.downcase == "billete"
              Dolar::Bna::Exchange.new(date).perform_bna_billete
              dolar_query =  Dolar::Bna::DolarCotization.where(date: date, dolar_type: @dolar_type).first
              dolar_buy = dolar_query.dolar_buy unless dolar_query.blank?
              dolar_sell = dolar_query.dolar_sell unless dolar_query.blank?
            else
              dolar_buy = dolar_query.dolar_buy unless dolar_query.blank?
              dolar_sell = dolar_query.dolar_sell unless dolar_query.blank?
              break
            end
          else
            dolar_buy = dolar_query.dolar_buy unless dolar_query.blank?
            dolar_sell = dolar_query.dolar_sell unless dolar_query.blank?
            break
          end
        end
        return dolar_buy, dolar_sell
      end

      def ars_to_dolar dolar_sell
        tax_pais = 1 + @aliquot
        valor = if !dolar_sell.nil?
          @value.to_f / (dolar_sell.to_f * tax_pais)
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
