variable "GITHUB_RUN_NUMBER" {}

group "default" {
  targets = [
    "ruby"
  ]
}

target "ruby" {
  name = "ruby-${tgt}"
  matrix = {
    tgt = [
      "default",
      "jemalloc",
      "nodejs",
      "nodejs-jemalloc"
    ]
  }

  target = tgt
  tags = [
    "acornsaustralia/ruby:3.1-${tgt}",
    "acornsaustralia/ruby:3.1-${tgt}-${GITHUB_RUN_NUMBER}"
  ]
  args = {
    "ROCKY_VERSION"    = "9"
    "RUBY_VERSION"     = "3.1"
    "POSTGRES_VERSION" = "16"
  }
}