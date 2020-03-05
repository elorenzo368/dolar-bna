module Dolar
  module Bna
    class TodayExchange

      def initialize(dolar_type='Billete')
        @dolar_type ||= dolar_type
      end

      def perform
        dolar = check_today_cotization()
        return dolar
      end

      private

      def check_today_cotization
        query = Dolar::Bna::DolarCotization.where(date: Date.today, dolar_type: @dolar_type).order("dolar_cotizations.created_at DESC").first
        #data = {compra: "-", venta: "-"}
        if query.nil?
          if @dolar_type == "Billete"
            data = Dolar::Bna::Exchange.new(Date.today).perform_bna_billete
          else
            data = Dolar::Bna::Exchange.new(Date.today).perform_bna_divisa
          end
        else
          data = {compra: query.dolar_buy, venta: query.dolar_sell}
        end
        return data
      end
    end
  end
end
