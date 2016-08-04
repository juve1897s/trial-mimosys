require "rubygems"
require "sinatra"
require "ruby-box"

get "/" do
  "Hello world!"
end

### 
#The Model
###
    class BoxUploader 
      require 'httmultiparty'
      include HTTMultiParty
      #base_uri 'https://api.box.com/2.0'
    end

    class File < ActiveRecord::Base
        attr_accessible :file
        attr_accessor :boxResponse

        FILE_STORE = File.join Rails.root, 'public', 'files'
        API_KEY = @myBoxApiKey
        AUTH_TOKEN = @myBoxAuthToken

        def file=(data) #uploaded file 
          filename = data.original_filename 
          path = File.join FILE_STORE, filename
          #### would like to bypass the file writing step
          File.open(path, "wb")  do |f| 
            f.write(data.read) 
          end
          #############
          File.open(path, "wb")  do |f| 
           boxResponse = BoxUploader.post('https://api.box.com/2.0/files/content', 
                :headers => { 'authorization' => 'BoxAuth api_key={API_KEY&auth_token=AUTH_TOKEN' },
                :body => { :folder_id      => '911', :filename => File.new(path)}
            )
          end  
    end

###
# The View
###
<!-- Invoke the Controller's "create" action -->
<h1>File Upload</h1>
<%= form_for @file, :html => {:multipart=>true} do |f| %>
  <p>
    <%= f.label :file %>
    <%= f.file_field :file %>
  </p>
  <p>
    <%= f.submit 'Create' %>
<% end %>
