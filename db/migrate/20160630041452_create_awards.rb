class CreateAwards < ActiveRecord::Migration
  class MigrationAward < ActiveRecord::Base
    self.table_name = :awards
    extend FriendlyId
    friendly_id :short_name, use: :slugged
  end
  
  def up
    create_table :awards do |t|
      t.string :name
      t.string :short_name
      t.string :slug
      t.decimal :default_minimum
      t.hstore :min_casual_rates
      t.hstore :min_permanent_rates
      
      t.timestamps null: false
    end
    
    add_index :awards, :slug, unique: true
    
    MigrationAward.create([
      { name: "National Employment Standards", short_name: "no_award", default_minimum: BigDecimal.new(21.61, 10),
      min_casual_rates: { "2016" => 22.13, "2015" => 21.61, "2014" => 21.09, "2013" => 20.46, "2012" => 19.95, "2011" => 19.39, "2010" => 18.75 },
      min_permanent_rates: { "2016" => 17.70, "2015" => 17.29, "2014" => 16.87, "2013" => 16.37, "2012" => 15.96, "2011" => 15.51, "2010" => 15.00 } },
      { name: "Horticulture Award 2010", short_name: "horticulture", default_minimum: BigDecimal.new(21.61, 10),
      min_casual_rates: { "2016" => 22.13, "2015" => 21.61, "2014" => 21.09, "2013" => 20.46, "2012" => 19.95, "2011" => 19.39, "2010" => 18.75 },
      min_permanent_rates: { "2016" => 17.70, "2015" => 17.29, "2014" => 16.87, "2013" => 16.37, "2012" => 15.96, "2011" => 15.51, "2010" => 15.00 } },
      { name: "Meat Industry Award 2010", short_name: "meat", default_minimum: BigDecimal.new(21.61, 10),
      min_casual_rates: { "2016" => 22.13, "2015" => 21.61, "2014" => 21.09, "2013" => 20.46, "2012" => 19.95, "2011" => 19.39, "2010" => 18.75 },
      min_permanent_rates: { "2016" => 17.70, "2015" => 17.29, "2014" => 16.87, "2013" => 16.37, "2012" => 15.96, "2011" => 15.51, "2010" => 15.00 } },
      { name: "Poultry Processing Award 2010", short_name: "poultry", default_minimum: BigDecimal.new(22.34, 10),
      min_casual_rates: { "2016" => 22.87, "2015" => 22.34, "2014" => 21.79, "2013" => 21.15, "2012" => 20.61, "2011" => 20.04, "2010" => 19.38 },
      min_permanent_rates: { "2016" => 18.30, "2015" => 17.87, "2014" => 17.43, "2013" => 16.92, "2012" => 16.49, "2011" => 16.03, "2010" => 15.50 } },
      { name: "Storage Services Award 2010", short_name: "storage", default_minimum: BigDecimal.new(23.09, 10),
      min_casual_rates: { "2016" => 23.64, "2015" => 23.09, "2014" => 22.52, "2013" => 21.87, "2012" => 21.32, "2011" => 20.71, "2010" => 20.03 },
      min_permanent_rates: { "2016" => 18.91, "2015" => 18.47, "2014" => 18.02, "2013" => 17.49, "2012" => 17.05, "2011" => 16.57, "2010" => 16.03 } }
    ])
  end
  
  def down
    drop_table :awards
  end
end
