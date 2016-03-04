module Helpers

  # @return [Object] screen sizes (width and height)
  def scene_size
    {
      width: MG::Director.shared.size.width,
      height: MG::Director.shared.size.height
    }
  end

  # @return [Object] coordinates of screen center
  # on axis x and y
  def scene_center
    {
      x: scene_size[:width] / 2,
      y: scene_size[:height] / 2
    }
  end

  # @return [Object] with random screen position
  # on axis x and y
  def random_position
    {
      x: Random.new.rand(0..scene_size[:width]),
      y: Random.new.rand(0..scene_size[:height])
    }
  end
end
