module Dolar
  module Bna
    class TodayExchange

      def initialize(dolar_type='Billete')
        @dolar_type ||= dolar_type
      end

      def perform
        billete, divisa = check_today_cotization()
        if @dolar_type == "Billete"
          return billete
        else
          return divisa
        end
      end

      private

      def check_today_cotization
        divisa_query = Dolar::Bna::DolarCotization.where(date: Date.today, dolar_type: "Divisa").first
        billete_query = Dolar::Bna::DolarCotization.where(date: Date.today, dolar_type: "Billete").first
        ddivisa = {compra: "-", venta: "-"}
        if divisa_query.nil?
          ddivisa = Dolar::Bna::Exchange.new(Date.today).perform_bna_divisa
        else
          dbillete = {compra: divisa_query.dolar_buy, venta: divisa_query.dolar_sell}
        end
        if billete_query.nil?
          dbillete = Dolar::Bna::Exchange.new(Date.today).perform_bna_billete
        else
          dbillete = {compra: billete_query.dolar_buy, venta: billete_query.dolar_sell}
        end
        return dbillete, ddivisa
      end
    end
  end
end
