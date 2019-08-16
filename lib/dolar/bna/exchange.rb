module Dolar
  module Bna
    class Exchange

      def initialize(fecha=Date.today)
        @fecha ||= fecha
      end

      def perform_bna_billete
        data = check_cotization("Billete", @fecha)
        save_in_db(data, "Billete") unless data.blank?
        return data
      end

      def perform_bna_divisa
        data = check_cotization("Divisa", @fecha)
        save_in_db(data, "Divisa") unless data.blank?
        return data
      end

      def variation_billete
        today_dolar = check_cotization("Billete", @fecha)
        yesterday_dolar = check_cotization("Billete", (@fecha - 1.days))
        unless (today_dolar.nil? || yesterday_dolar.nil?)
          porcentual_variation = ((today_dolar[:venta] - yesterday_dolar[:venta]) / (yesterday_dolar[:venta]))
          porcentual_variation = "#{(porcentual_variation * 100).round(2)}%"
          return porcentual_variation
        else
          return "0%"
        end
      end

      private

      def check_cotization dolar_type, date
        query = Dolar::Bna::DolarCotization.where(date: date, dolar_type: dolar_type).first
        ddolar = nil
        if query.nil?
          if dolar_type == "Divisa"
            ddolar = get_dolar_divisa()
          else
            ddolar = get_dolar()
          end
        else
          ddolar = {compra: query.dolar_buy, venta: query.dolar_sell}
        end
        return ddolar
      end

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
