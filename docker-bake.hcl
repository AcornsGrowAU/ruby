variable "GITHUB_RUN_NUMBER" {
  default = null
}

group "default" {
  targets = [
    "ruby"
  ]
}

target "ruby" {
  name = "ruby-${replace(rb, ".", "-")}-${tgt}"
  matrix = {
    rb = [
        "3.3",
        "4.0"
    ]
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
    "acornsaustralia/ruby:${rb}-${tgt}",
    GITHUB_RUN_NUMBER != null ? "acornsaustralia/ruby:${rb}-${tgt}-${GITHUB_RUN_NUMBER}" : ""
  ]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
  args = {
    "ROCKY_VERSION"    = "10"
    "RUBY_VERSION"     = rb
    "POSTGRES_VERSION" = "18"
  }
}
