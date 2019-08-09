FactoryBot.define do
  factory :dolar_cotization do
    date {Date.today}
    dolar_type {["Divisa", "Billete"].sample}
    dolar_buy {Math.random(45..50)}
    dolar_sell {Math.random(45..50)}
  end
end
