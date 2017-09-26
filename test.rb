require 'pp'
require 'aws-sdk'
require 'open-uri'

s3 = Aws::S3::Client.new

image_data = open('http://tkaaw.us/u/yomyomyom.gif')
filename = 'testing.gif'

my_file = File.new(filename, 'wb')

if image_data.respond_to?(:read)
  IO.copy_stream(image_data, my_file)
else
  my_file.write(image_data)
end

resp = s3.put_object(
  acl: 'public-read',
  body: my_file,
  bucket: 'jumbo-gifs',
  key: "exampleobject",
)

resp = s3.list_objects(bucket: 'jumbo-gifs', max_keys: 5)

resp.contents.each do |object|
  puts "#{object.key} => #{object.etag}"
end
