#  Scrolls LOG_LEVEL_MAP
#  "emergency" => 0,
#  "alert"     => 1,
#  "critical"  => 2,
#  "error"     => 3,
#  "warning"   => 4,
#  "notice"    => 5,
#  "info"      => 6,
#  "debug"     => 7


unless ENV["LOG_LEVEL"]
  rails_scrolls_level_map = {
      0 => 7,
      1 => 6,
      2 => 4,
      3 => 3,
      4 => 1,
      5 => 0
  }
  Scrolls::Log::LOG_LEVEL = rails_scrolls_level_map[Rails.logger.level]
end
