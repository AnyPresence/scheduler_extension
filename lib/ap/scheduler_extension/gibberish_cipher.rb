require 'gibberish/aes'
require 'mongoid'
require 'mongoid-encrypted-fields'

# Borrowed from: https://github.com/KoanHealth/mongoid-encrypted-fields/blob/master/examples/gibberish_cipher.rb
#
# Gibberish uses a unique salt for every encryption, but we need the same text to return the same ciphertext
# so Searching for encrypted field will work
class AP::SchedulerExtension::Scheduler::GibberishCipher

  def initialize(password, salt=nil)
    @cipher = Gibberish::AES.new(password)
    @salt = salt
  end

  def encrypt(data)
    if @salt
      @cipher.encrypt(data, salt: @salt) 
    else 
      @cipher.encrypt(data)
    end
  end

  def decrypt(data)
    @cipher.decrypt(data)
  end

end

key = (!Rails.env.test?) ? ENV['ENCRYPTION_PASSWORD'] : "test"

raise "A key is needed. Please set the env variable ENCRYPTION_PASSWORD" if key.blank?

Mongoid::EncryptedFields.cipher = AP::SchedulerExtension::Scheduler::GibberishCipher.new(key)
