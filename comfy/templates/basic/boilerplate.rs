use super::*;

impl GameState {
    pub fn new(_c: &mut EngineContext) -> Self {
        Self::default()
    }
}

pub struct GameContext<'a, 'b: 'a> {
    pub engine: &'a mut EngineContext<'b>,
    pub state: &'a mut GameState,
}

pub fn make_context<'a, 'b: 'a>(
    state: &'a mut GameState,
    engine: &'a mut EngineContext<'b>,
) -> GameContext<'a, 'b> {
    GameContext { engine, state }
}
