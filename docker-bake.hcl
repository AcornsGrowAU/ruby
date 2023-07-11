variable "GITHUB_RUN_NUMBER" {
}

group "default" {
  targets = [
    "r8-jemalloc",
    "r9-jemalloc",
    "r8",
    "r9"
  ]
}

target "r8-jemalloc" {
  dockerfile = "Dockerfile"
  target     = "jemalloc"
  tags       = ["acornsaustralia/ruby:2.7-jemalloc", "acornsaustralia/ruby:2.7-jemalloc-${GITHUB_RUN_NUMBER}"]
  args = {
    "ROCKY_VERSION" = "8"
    "RUBY_VERSION"   = "2.7"
  }
  platforms = ["linux/amd64", "linux/arm64"]
}

target "r9-jemalloc" {
  dockerfile = "Dockerfile"
  target     = "jemalloc"
  tags       = ["acornsaustralia/ruby:3.1-jemalloc", "acornsaustralia/ruby:3.1-jemalloc-${GITHUB_RUN_NUMBER}"]
  args = {
    "ROCKY_VERSION" = "9"
    "RUBY_VERSION"   = "3.1"
  }
}

target "r8" {
  dockerfile = "Dockerfile"
  target     = "default"
  tags       = ["acornsaustralia/ruby:2.7", "acornsaustralia/ruby:2.7-${GITHUB_RUN_NUMBER}"]
  args = {
    "ROCKY_VERSION" = "8"
    "RUBY_VERSION"   = "2.7"
  }
}

target "r9" {
  dockerfile = "Dockerfile"
  target     = "default"
  tags       = ["acornsaustralia/ruby:3.1", "acornsaustralia/ruby:3.1-${GITHUB_RUN_NUMBER}"]
  args = {
    "ROCKY_VERSION" = "9"
    "RUBY_VERSION"   = "3.1"
  }
}
