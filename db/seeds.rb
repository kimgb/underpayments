# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = Admin.new(email: "kbuckley@nuw.org.au", password: "ch3ng4M1chANGEmePrEtTYplz")
admin.save!

# start_page = Page.new(
#   title: "Am I Underpaid?",
#   slug: "start",
#   content: File.read(Rails.root + "db" + "pages" + "start.html")
# )
# start_page.save!
