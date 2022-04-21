# frozen_string_literal: true

module FixturesHelper
  FIXTURES_DIR = File.join('spec', 'fixtures')

  def json_fixture(path)
    JSON.parse(File.read(File.join(FIXTURES_DIR, path)))
  end
end
