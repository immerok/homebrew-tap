# typed: false
# frozen_string_literal: true

require "io/console"
require "base64"

class RokLatest < Formula
  desc "rok is the official CLI for Immerok Cloud (head version)"
  homepage "https://github.com/immerok"

  option "with-dev", "Latest version for dev environment"
  option "with-sandbox", "Latest version for sandbox environment"

  # Determine environment
  rok_environment = ""
  if build.with? "dev"
    rok_environment = "dev"
  elsif build.with? "sandbox"
    rok_environment = "sandbox"
  end
  
  # Build basic auth header for non-production environments
  auth_header = ""
  if rok_environment != ""
    username = ENV["HOMEBREW_ROK_CACHED_USER"]
    if username == nil
      username = ENV["HOMEBREW_ROK_#{rok_environment.upcase}_USER"]
    end
    if username == nil || username == ""
      print "Username: "
      username = STDIN.gets.chomp

      ENV["HOMEBREW_ROK_CACHED_USER"] = username
    end
    
    password = ENV["HOMEBREW_ROK_CACHED_PW"]
    if password == nil
      password = STDIN.getpass("Password:")
    
      ENV["HOMEBREW_ROK_CACHED_PW"] = password
    end
    
    auth_header = "Authorization: Basic " + Base64.encode64("#{username}:#{password}")
  end
  
  # Prepend environment with "." if non-production.
  if rok_environment != "" 
    rok_environment = ".#{rok_environment}"
  end
  
  # Determine OS
  rok_os = ""
  if OS.mac?
    rok_os = "darwin"
  elsif OS.linux?
    rok_os = "linux"
  end

  # Determine architecture
  rok_arch = ""
  if Hardware::CPU.arm?
    rok_arch = "arm64"
  elsif Hardware::CPU.intel?
    rok_arch = "amd64"
  end

  odie "Your operating system is not supported." if rok_os == ""
  odie "Your CPU architecture is not supported." if rok_arch == ""

  head "https://releases#{rok_environment}.immerok.cloud/rok/latest/rok-#{rok_os}-#{rok_arch}.tar.gz", header: auth_header

  def install
    bin.install "rok"
    generate_completions_from_executable("#{bin}/rok", "completion")
  end

  test do
    system "#{bin}/rok version"
  end
end
