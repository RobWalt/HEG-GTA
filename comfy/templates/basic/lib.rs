pub mod boilerplate;
pub use boilerplate::*;
use comfy::*;

#[derive(Default)]
pub struct GameState {}

pub fn setup(_c: &mut GameContext) {}

pub fn update(c: &mut GameContext) {
    let GameState {} = &mut c.state;
    draw_rect(Vec2::ZERO, Vec2::ONE, Color::rgb(0.0, 0.1, 0.2), 0);
}
