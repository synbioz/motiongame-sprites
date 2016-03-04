class MainScene < MG::Scene

  def initialize(name)
    self.gravity = [0, 0]

    @time = 0
    @zombie_update_position = 0
    @hero_path = "characters/#{ name.downcase }"

    add_scene

    add_survivor(name.downcase)
    add_zombie

    on_touch_begin do |touch|
      animate_survivor(direction(touch))
      @survivor.move_to(direction(touch), 2)
    end

    on_contact_begin { MG::Director.shared.replace(GameOverScene.new(@time, name.downcase)) }

    start_update
  end

  ############
  # Characters
  ############
  def add_zombie
    @zombie = MG::Sprite.new("zombie.png")
    @zombie.attach_physics_box
    @zombie.position = [400, scene_center[:y]]
    @zombie.contact_mask = 1

    add @zombie
  end

  def add_survivor(name)
    @survivor = MG::Sprite.new("characters/#{ name }/face.png")
    @survivor.attach_physics_box
    @survivor.position = [100, scene_center[:y]]
    @survivor.contact_mask = 1
    @survivor.scale += 1

    add @survivor
  end

  ############
  # Scenes
  ############
  def add_scene
    add_ground
    add_carpet
    add_wall_effect
    add_wall_synbioz
    add_vertical_walls
    add_horizontal_walls
    add_corners
  end

  def add_ground
    sprite = MG::Sprite.new("sprites/ground.png")
    axes = screen_coordinates(sprite)

    axes.each do |axis|
      ground = MG::Sprite.new("sprites/ground.png")
      ground.anchor_point = [0, 0]
      ground.position = [axis[0], axis[1]]

      add ground
    end
  end

  def add_carpet
    carpet = MG::Sprite.new("sprites/carpet.png")
    carpet.position = [scene_center[:x], scene_center[:y]]
    carpet.scale += 1.5

    add carpet
  end

  def add_wall_effect
    sprite = MG::Sprite.new("sprites/wall.png")
    coordinates = axis_bounds(sprite, "width")

    coordinates.each do |coordinate|
      wall = MG::Sprite.new("sprites/wall.png")
      anchor = coordinate[1] == 0 ? [0, 0] : [0, 1]
      wall.anchor_point = anchor
      wall.position = [coordinate[0], coordinate[1] - wall.size.height]

      add wall
    end
  end

  def add_wall_synbioz
    wall = MG::Sprite.new("sprites/wall-synbioz.png")
    wall.anchor_point = [0.5, 1]
    wall.position = [scene_center[:x], scene_size[:height] - wall.size.height]

    add wall
  end

  def add_horizontal_walls
    sprite = MG::Sprite.new("sprites/top-wall-x.png")
    coordinates = axis_bounds(sprite, "width")

    coordinates.each do |coordinate|
      wall = MG::Sprite.new("sprites/top-wall-x.png")
      anchor = coordinate[1] == 0 ? [0, 0] : [0, 1]
      wall.anchor_point = anchor
      wall.attach_physics_box
      wall.dynamic = false
      wall.position = [coordinate[0], coordinate[1]]

      add wall
    end
  end

  def add_vertical_walls
    sprite = MG::Sprite.new("sprites/top-wall-y.png")
    coordinates = axis_bounds(sprite, "height")

    coordinates.each do |coordinate|
      wall = MG::Sprite.new("sprites/top-wall-y.png")
      anchor = coordinate[0] == 0 ? [0, 0] : [1, 0]
      wall.attach_physics_box
      wall.dynamic = false
      wall.anchor_point = anchor
      wall.position = [coordinate[0], coordinate[1]]

      add wall
    end
  end

  def add_corners
    tl_corner = MG::Sprite.new("sprites/corner-tl.png")
    tr_corner = MG::Sprite.new("sprites/corner-tr.png")
    bl_corner = MG::Sprite.new("sprites/corner-bl.png")
    br_corner = MG::Sprite.new("sprites/corner-br.png")

    [tl_corner, tr_corner, bl_corner, br_corner].each do |corner|
      corner.attach_physics_box
      corner.dynamic = false
    end

    tl_corner.anchor_point, tl_corner.position = [0, 1], [0, scene_size[:height]]
    bl_corner.anchor_point, bl_corner.position = [0, 0], [0, 0]
    tr_corner.anchor_point, tr_corner.position = [1, 1], [scene_size[:width], scene_size[:height]]
    br_corner.anchor_point, br_corner.position = [1, 0], [scene_size[:width], 0]

    add tl_corner
    add tr_corner
    add bl_corner
    add br_corner
  end

  ############
  # Methods
  ############

  def direction(touch)
    distance_x = (touch.location.x - @survivor.position.x).abs
    distance_y = (touch.location.y - @survivor.position.y).abs

    if distance_y > distance_x
      [@survivor.position.x, touch.location.y]
    else
      [touch.location.x, @survivor.position.y]
    end
  end

  def animate_survivor(direction)
    img_y = image_direction(direction, "y")
    img_x = image_direction(direction, "x")

    frames = if direction[0] == @survivor.position.x
      define_frames("#{ @hero_path }/#{ img_y }")
    else
      define_frames("#{ @hero_path }/#{ img_x }")
    end

    @survivor.animate(frames, 0.2, 2)
  end

  def image_direction(direction, axis)
    if axis == "y"
      (direction[1] - @survivor.position.y) < 0 ? "face" : "back"
    elsif axis == "x"
      (direction[0] - @survivor.position.x) < 0 ? "left" : "right"
    else
      raise "Axis error"
    end
  end

  def axis_bounds(sprite, axis)
    val = axis
    current_size = scene_size[axis.to_sym]
    axis_sprites = (current_size / sprite.size.method(axis).call).to_i
    switch_position = val == "width" ? scene_size[:height] : scene_size[:width]

    coordinates = []

    2.times do |bound|
      bound_coordinate = bound == 0 ? bound : switch_position

      axis_sprites.times do |axis|
        coordinates << if val == "width"
          [axis * sprite.size.width, bound_coordinate]
        else
          [bound_coordinate, axis * sprite.size.height]
        end
      end
    end

    coordinates
  end

  def define_frames(path)
    [1, 2].map { |i| "#{ path }-#{ i }.png" }
  end

  def screen_coordinates(sprite)
    x_sprites = (scene_size[:width] / sprite.size.width).to_i + 1
    y_sprites = (scene_size[:height] / sprite.size.height).to_i + 1

    coordinates = []

    x_sprites.times do |x|
      y_sprites.times do |y|
        coordinates << [x * sprite.size.width, y * sprite.size.height]
      end
    end

    coordinates
  end

  def update(delta)

    @time += delta
    @zombie_update_position += delta

    if @zombie_update_position >= 2.0
      @zombie.move_to([random_position[:x], random_position[:y]], 1)
      @zombie.scale += 0.1
      @zombie_update_position = 0
    end
  end
end
