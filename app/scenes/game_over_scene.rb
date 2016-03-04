class GameOverScene < MG::Scene

  def initialize(score, name)
    @name = name
    game_over_label
    score(score)

    retry_button(name)
    new_button
  end

  def game_over_label
    label = MG::Text.new("Game over...", "Arial", 96)
    label.position = [scene_center[:x], scene_center[:y] + 80]

    add label
  end

  def score(score)
    time = score.round(2)
    score = MG::Text.new("You survived #{ time }s", "Arial", 40)
    score.position = [scene_center[:x], scene_center[:y]]

    add score
  end

  def new_button
    button = MG::Button.new("New game")
    button.font_size = 35
    button.position = [scene_center[:x] - 120, scene_center[:y] - 140]
    button.color = [1, 0.8, 0.6]
    button.on_touch { MG::Director.shared.replace(SurvivorScene.new) }

    add button
  end

  def retry_button(name)
    button = MG::Button.new("Retry")
    button.font_size = 35
    button.position = [scene_center[:x] + 120, scene_center[:y] - 140]
    button.color = [1, 0.8, 0.6]
    button.on_touch { MG::Director.shared.replace(MainScene.new("#{ @name }")) }

    add button
  end
end
