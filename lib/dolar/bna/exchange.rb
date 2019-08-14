module Dolar
  module Bna
    class Exchange

      def initialize(fecha=Date.today)
        @fecha ||= fecha
      end

      def perform_bna_billete
        data = get_dolar()
        save_in_db(data, "Billete") unless data.blank?
        return data
      end

      def perform_bna_divisa
        data = get_dolar_divisa()
        save_in_db(data, "Divisa") unless data.blank?
        return data
      end

      private

      def get_dolar
        require "open-uri"
        data = {}
        mechanize = Mechanize.new
        mechanize.user_agent_alias = "Android"
        begin
          Timeout.timeout(20) do
            url = "http://www.bna.com.ar/Cotizador/HistoricoPrincipales?id=billetes&fecha=#{@fecha.day}%2F#{@fecha.month}%2F#{@fecha.year}&filtroEuro=0&filtroDolar=1"
            value = obtain_dolar_from_html(url, mechanize, data)
            return value
          end
        rescue => ex
          pp ex.message
          return nil
        end
      end

      def get_dolar_divisa
        require "open-uri"
        data = {}
        mechanize = Mechanize.new
        mechanize.user_agent_alias = "Android"
        begin
          Timeout.timeout(20) do
            url = "http://www.bna.com.ar/Cotizador/MonedasHistorico"
            value = obtain_dolar_from_html(url, mechanize, data)
            return value
          end
        rescue => ex
          pp ex.message
          return nil
        end
      end

      def obtain_dolar_from_html(url, mechanize, data)

        page = mechanize.get(url)
        doc = Nokogiri::HTML(page.body, "UTF-8")
        doc.xpath("//td").each_with_index do |node, index|
          data[index] = node.text
        end
        correct_date = "#{@fecha.day.to_i}/#{@fecha.month.to_i}/#{@fecha.year.to_i}"
        i = data.key(correct_date)
        if !i.nil?
          dolar_compra = BigDecimal(data[i - 2].tr(",", ".")).truncate(3).to_f
          dolar_venta = BigDecimal(data[i - 1].tr(",", ".")).truncate(3).to_f
        else
          dolar_compra = BigDecimal(data[1].tr(",", ".")).truncate(3).to_f
          dolar_venta = BigDecimal(data[2].tr(",", ".")).truncate(3).to_f
        end
        return {compra: dolar_compra, venta: dolar_venta}
      end

      def save_in_db data, dolar_type
        Dolar::Bna::DolarCotization.create(date: @fecha, dolar_type: dolar_type, dolar_buy: data[:compra], dolar_sell: data[:venta])
      end

    end
  end
end
