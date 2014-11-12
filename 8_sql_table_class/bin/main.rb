require_relative('../lib/sql_table')

SQLTable.new.create_table('Employee') do |t|
  t.boolean :is_new, default: false
  t.string :name, default: 'Udit', length:25
  t.number :salary, default: 10000, null: true
  t.datetime :joined_on, default: '2000-12-01'
  t.datetime :left_on, default: nil
end
