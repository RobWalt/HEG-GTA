pub mod boilerplate;
pub use boilerplate::*;
use comfy::*;

#[derive(Default)]
pub struct GameState {
    snake_head: SnakeHead,
    snake_parts: Vec<SnakePart>,
    time: f32,
}

#[derive(Default)]
pub struct SnakeHead {
    pos: Vec2,
    dir: Vec2,
}

#[derive(Default)]
pub struct SnakePart {
    pos: Vec2,
}

pub fn setup(c: &mut GameContext) {
    c.state.snake_head = SnakeHead {
        pos: Vec2::new(0.0, 0.0),
        dir: Vec2::X,
    };
    c.state.snake_parts = vec![];
}
pub fn update(c: &mut GameContext) {
    let GameState {
        snake_head,
        snake_parts,
        time,
    } = &mut c.state;

    *time += delta();

    if *time > 1.0 {
        *time = 0.0;
        let last_pos = snake_parts.last().map_or(snake_head.pos, |part| part.pos);
        let last_dir = match (snake_parts.get(snake_parts.len() - 2), snake_parts.last()) {
            (None, None) => -snake_head.dir,
            (None, Some(p)) => p.pos - snake_head.pos,
            (Some(l), Some(p)) => p.pos - l.pos,
            _ => unreachable!(),
        }
        .normalize();
        snake_parts.push(SnakePart {
            pos: last_pos + last_dir,
        });
    }

    draw_rect(
        snake_head.pos,
        Vec2::new(1.0, 1.0),
        Color::rgb(0.0, 0.1, 0.2),
        0,
    );

    for (i, SnakePart { pos }) in snake_parts.iter().enumerate() {
        draw_rect(
            *pos,
            Vec2::new(1.0, 1.0),
            Color::rgb(i as f32 * 0.05, 0.1, 0.2),
            0,
        );
    }

    if snake_parts.len() >= 2 {
        for i in (1..snake_parts.len()).rev() {
            let dir = snake_parts[i - 1].pos - snake_parts[i].pos;
            snake_parts[i].pos += dir.normalize() * 0.05 * dir.length().powi(20);
        }
    }
    if !snake_parts.is_empty() {
        let dir = snake_head.pos - snake_parts[0].pos;
        snake_parts[0].pos += dir.normalize() * 0.05 * dir.length().powi(20);
    }
    snake_head.pos += snake_head.dir * 0.05;

    if is_key_pressed(KeyCode::Right) {
        snake_head.dir = Vec2::X;
    }
    if is_key_pressed(KeyCode::Left) {
        snake_head.dir = -Vec2::X;
    }
    if is_key_pressed(KeyCode::Up) {
        snake_head.dir = Vec2::Y;
    }
    if is_key_pressed(KeyCode::Down) {
        snake_head.dir = -Vec2::Y;
    }
}
