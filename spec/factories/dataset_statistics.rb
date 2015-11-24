require 'factory_girl'

FactoryGirl.define do

  factory :dataset_statistics do
    initialize_with do
      new({
            'table_type' => 'BASE_TABLE',
            'row_count' => '1000',
            'column_count' => '5',
            'description' => 'This is a nice table.',
            'last_analyzed' => Time.parse('2012-06-06 23:02:42.40264+00'),
            'disk_size' => 2097152,
            'partition_count' => '0',
            'definition' => "SELECT * FROM foo"
          })
    end
  end

end

