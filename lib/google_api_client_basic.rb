# require 'googleauth'
# require 'google/apis/compute_v1'


require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/file_storage'
require 'google/api_client/auth/installed_app'





require "google_api_client_basic/version"



module GoogleApiClientBasic

  API_VERSION = 'v2'
  ROOT_PATH = "#{File.dirname(__FILE__)}/.."
  CACHED_API_FILE = "#{ROOT_PATH}/secret/drive-#{API_VERSION}.cache"
  CREDENTIAL_STORE_FILE = "#{ROOT_PATH}/secret/credential-oauth2.json"

  def self.setup
    client = Google::APIClient.new(:application_name => 'Ruby Drive sample',
        :application_version => '1.0.0')

    # FileStorage stores auth credentials in a file, so they survive multiple runs
    # of the application. This avoids prompting the user for authorization every
    # time the access token expires, by remembering the refresh token.
    # Note: FileStorage is not suitable for multi-user applications.
    file_storage = Google::APIClient::FileStorage.new(CREDENTIAL_STORE_FILE)
    if file_storage.authorization.nil?
      client_secrets = Google::APIClient::ClientSecrets.load("#{ROOT_PATH}/secret/client_secret.json")
      # The InstalledAppFlow is a helper class to handle the OAuth 2.0 installed
      # application flow, which ties in with FileStorage to store credentials
      # between runs.
      flow = Google::APIClient::InstalledAppFlow.new(
        :client_id => client_secrets.client_id,
        :client_secret => client_secrets.client_secret,
        :scope => ['https://www.googleapis.com/auth/drive']
      )
      client.authorization = flow.authorize(file_storage)
    else
      client.authorization = file_storage.authorization
    end

    drive = nil
    # Load cached discovered API, if it exists. This prevents retrieving the
    # discovery document on every run, saving a round-trip to API servers.
    if File.exists? CACHED_API_FILE
      File.open(CACHED_API_FILE) do |file|
        drive = Marshal.load(file)
      end
    else
      drive = client.discovered_api('drive', API_VERSION)
      File.open(CACHED_API_FILE, 'w') do |file|
        Marshal.dump(drive, file)
      end
    end

    return client, drive
  end

  # Handles files.insert call to Drive API.
  def self.insert_file(client, drive)
    # Insert a file
    file = drive.files.insert.request_schema.new({
      'title' => 'My document',
      'description' => 'A test document',
      'mimeType' => 'text/plain'
    })

    media = Google::APIClient::UploadIO.new("#{ROOT_PATH}/etc/document.txt", 'text/plain')
    result = client.execute(
      :api_method => drive.files.insert,
      :body_object => file,
      :media => media,
      :parameters => {
        'uploadType' => 'multipart',
        'alt' => 'json'})

    # Pretty print the API result
    jj result.data.to_hash
  end

  def self.run
    client, drive = setup()
    insert_file(client, drive)
  end
end
