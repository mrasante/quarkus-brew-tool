class QuarkusHttpServer < Formula
  desc "Quarkus HTTP Server"
  homepage "https://quarkus.io/"
  url "https://github.com/mrasante/homebrew.git", using: :git, branch: "main"
  version "1.0.0"

  depends_on "openjdk" => :recommended

  def install
    # Create the target directory structure
    mkdir_p "#{prefix}/libexec"
    
    # Copy your application files to the prefix
    cp_r ".", "#{prefix}/libexec/"
    
    # Make sure the jar file is executable
    chmod 0755, "#{prefix}/libexec/quarkus-app/quarkus-run.jar"
    
    # Create a launch script
    (bin/"quarkus-http-server").write <<~EOF
      #!/bin/bash
      cd "#{prefix}/libexec/quarkus-app" || exit 1
      exec java -jar quarkus-run.jar "$@"
    EOF
    
    chmod +x bin/"quarkus-http-server"
  end

  service do
    run [Formula["openjdk"].opt_bin/"java", "-jar", "#{prefix}/libexec/quarkus-app/quarkus-run.jar"]
    keep_alive true
    working_dir "#{prefix}/libexec/quarkus-app"
    log_path "#{prefix}/var/log/quarkus-http-server.log"
    error_log_path "#{prefix}/var/log/quarkus-http-server-error.log"
  end

  test do
    # Test that the binary exists and is executable
    assert_predicate bin/"quarkus-http-server", :executable?
  end
end