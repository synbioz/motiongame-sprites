class SurvivorScene < MG::Scene
  def initialize
    choose_label
    added_survivors
  end

  def choose_label
    label = MG::Text.new("Choose your survivor", "Arial", 80)
    label.color = [0.7, 0.7, 0.7]
    label.position = [scene_center[:x], scene_size[:height] - 100]

    add label
  end

  def added_survivors

    ["Numa", "Theo", "Cedric", "Francois"].each_with_index do |name, index|
      button = MG::Button.new("#{name}")
      button.font_size = 35
      button.position = [scene_center[:x], (scene_size[:height] - 200) - (index * 50)]
      button.on_touch { MG::Director.shared.replace(MainScene.new(name)) }

      add button
    end
  end
end
