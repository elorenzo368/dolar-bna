require "dolar/bna/version"
require 'dolar/bna/exchange'
require 'dolar/bna/convert'
require "dolar/app/models/dolar_cotization.rb"
module Dolar
  module Bna
    class Error < StandardError; end

    def self.root
      File.expand_path '../..', __FILE__
    end

    autoload :Exchanger, "dolar/bna/exchange"
    autoload :Converter, "dolar/bna/convert"

    initializer "dolar.bna" do |app|
      ActionView::Base.send :include, Dolar::Bna::DolarHelpers
    end

  end
end
