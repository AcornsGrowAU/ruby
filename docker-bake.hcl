variable "GITHUB_RUN_NUMBER" {
}

group "default" {
  targets = [
    "r27-jemalloc",
    "r30-jemalloc",
    "r27",
    "r30"
  ]
}

target "r27-jemalloc" {
  dockerfile = "Dockerfile"
  target     = "jemalloc"
  tags       = ["acornsaustralia/ruby-jemalloc:2.7-jemalloc", "acornsaustralia/ruby-jemalloc:2.7-jemalloc-${GITHUB_RUN_NUMBER}"]
  args = {
    "FEDORA_VERSION" = "35"
    "RUBY_VERSION"   = "2.7"
  }
  platforms = ["linux/amd64", "linux/arm64"]
}

target "r30-jemalloc" {
  dockerfile = "Dockerfile"
  target     = "jemalloc"
  tags       = ["acornsaustralia/ruby:3.0-jemalloc", "acornsaustralia/ruby:3.0-jemalloc-${GITHUB_RUN_NUMBER}"]
  args = {
    "FEDORA_VERSION" = "35"
    "RUBY_VERSION"   = "3.0"
  }
}

target "r27" {
  dockerfile = "Dockerfile"
  target     = "base"
  tags       = ["acornsaustralia/ruby:2.7", "acornsaustralia/ruby:2.7-${GITHUB_RUN_NUMBER}"]
  args = {
    "FEDORA_VERSION" = "35"
    "RUBY_VERSION"   = "2.7"
  }
}

target "r30" {
  dockerfile = "Dockerfile"
  target     = "base"
  tags       = ["acornsaustralia/ruby:3.0", "acornsaustralia/ruby:3.0-${GITHUB_RUN_NUMBER}"]
  args = {
    "FEDORA_VERSION" = "35"
    "RUBY_VERSION"   = "3.0"
  }
}
