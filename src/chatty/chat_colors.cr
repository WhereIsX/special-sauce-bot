require "colorize"

# a namespace to wrap up a bundle of functions
# Colors.using_hash("whereisx") # => :light_gray
module Colors
  def self.from_username(username : String) : Symbol
    colors = [
      :light_gray,
      :dark_gray,
      :light_red,
      :light_green,
      :light_yellow,
      :light_blue,
      :light_magenta,
      :light_cyan
    ]
    return colors[username.hash % 8]
  end

  def self.from_hex(hex : String) : Colorize::ColorRGB
    if hex.size != 7
      raise "you wat. thats not an appropriate hex size; want 7, got #{hex.size}"
    end
    # hex = #FF69B4
    rgb = hex[1..].hexbytes
    return Colorize::ColorRGB.new(rgb[0], rgb[1], rgb[2])
  end
end
