{{#brewRequireRelative}}
require_relative "{{.}}"
{{/brewRequireRelative}}

class {{brewFormulaName}} < Formula
  desc "{{projectDescription}}"
  homepage "{{projectLinkHomepage}}"
  url "{{distributionUrl}}"{{#brewDownloadStrategy}}, :using => {{.}}{{/brewDownloadStrategy}}
  version "{{projectVersion}}"
  sha256 "{{distributionChecksumSha256}}"
  license "{{projectLicense}}"

  {{#brewHasLivecheck}}
  livecheck do
    {{#brewLivecheck}}
    {{.}}
    {{/brewLivecheck}}
  end
  {{/brewHasLivecheck}}


  {{#brewDependencies}}
  depends_on {{.}}
  {{/brewDependencies}}

  def install

    # Install all bash scripts to the bin directory
    # https://docs.brew.sh/Formula-Cookbook#bininstall-foo
    # Bin.install install the script into `/home/linuxbrew/.linuxbrew/bin/`
    bin.install Dir["bin/*"]

    # Install man pages:
    # man1.install Dir["man1/*.1"]

    # Library installation
    libexec.install Dir["lib/*.sh"]
    # Not: lib.install Dir["lib/*.sh"]
    # because it will install it as shared library
    # and we get the following link problem
    # libxxx is a symlink belonging to giture. You can unlink it

    # Installing the charts
    pkgshare.install "charts"

    # Injecting the path and version in the header
    Dir["#{bin}/*"].each do |f|
      next unless File.file?(f)

      content = File.read(f).lines
      new_header = <<~EOS
        #!/usr/bin/env bash
        BASHLIB_PATH="#{libexec}"
        PROJECT_VERSION="{{projectVersion}}"
      EOS

      File.write(f, new_header + content.drop(1).join)
    end

end

  # https://rubydoc.brew.sh/Formula#caveats-instance_method
  def caveats
    scripts_list = bin.children.map { |script| "  - #{script.basename}" }.join("\n")
    <<~EOS
      The following scripts have been installed:

      #{scripts_list}

    EOS
  end

  test do

    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail, and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test dockenv`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.

    output = shell_output("#{bin}/git-exec --help")
    # assert_match "{{projectVersion}}", output

  end
end
