RSpec.describe Databrain do
  it "has a version number" do
    expect(Databrain::VERSION).not_to be nil
  end

  it "q does simple request" do
    query = [
      :find, :n?, :p?,
      # :in, "$",
      :where, [:e?, :name, :n?],
              [:e?, :price, :p?],
              [:e?, :available, true]
    ]

    db = [
      [1, :name, "Milk"],
      [1, :price, 100],
      [1, :available, true],
      [2, :name, "Pear"],
      [2, :price, 80],
      [2, :available, false],
      [3, :name, "Beaf"],
      [3, :price, 160],
      [3, :available, true]
    ]

    result = [
      ["Milk", 100],
      ["Beaf", 160]
    ]

    expect(Databrain.q(query, db)).to eq result
  end
end
