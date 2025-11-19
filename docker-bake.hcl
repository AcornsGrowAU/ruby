variable "GITHUB_RUN_NUMBER" {
  default = null
}

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
  pull   = true
  tags = [
    "acornsaustralia/ruby:3.3-${tgt}-new",
    GITHUB_RUN_NUMBER != null ? "acornsaustralia/ruby:3.3-${tgt}-${GITHUB_RUN_NUMBER}-new" : ""
  ]
  platforms = [
    "linux/amd64"
  ]
  args = {
    "ROCKY_VERSION"    = "9"
    "RUBY_VERSION"     = "3.3"
    "POSTGRES_VERSION" = "17"
  }
}
