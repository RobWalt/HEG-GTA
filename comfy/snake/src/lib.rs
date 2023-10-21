pub mod boilerplate;
pub use boilerplate::*;
use comfy::*;

#[derive(Default)]
pub struct GameState {
    snake_head: SnakeHead,
    snake_parts: Vec<SnakePart>,
    food: Option<Food>,
    speed: f32,
}

#[derive(Clone, Default)]
pub struct SnakeHead {
    pos: Vec2,
    dir: Vec2,
}

#[derive(Clone, Default)]
pub struct SnakePart {
    pos: Vec2,
}

#[derive(Clone, Default)]
pub struct Food {
    pos: Vec2,
}

const SNAKE_SIZE: Vec2 = Vec2::ONE;

pub fn setup(c: &mut GameContext) {
    c.state.speed = 0.05;
}

pub fn update(c: &mut GameContext) {
    let GameState {
        snake_head,
        snake_parts,
        food,
        speed,
    } = &mut c.state;

    crash_if_hit(snake_head, snake_parts);
    spawn_food_if_non_existent(food);

    if snake_hits_food(food, snake_head) {
        add_new_part(snake_parts, snake_head);
        despawn_food(food);
        *speed = speed.ln_1p() * 1.15;
        println!("{speed}");
    }

    draw_snake(snake_head, snake_parts);
    draw_food(food);

    move_snake(snake_head, snake_parts, *speed);

    change_snake_direction(snake_head);
}

fn change_snake_direction(snake_head: &mut SnakeHead) {
    [
        (KeyCode::Right, Vec2::X),
        (KeyCode::Left, Vec2::NEG_X),
        (KeyCode::Up, Vec2::Y),
        (KeyCode::Down, Vec2::NEG_Y),
    ]
    .into_iter()
    .for_each(|(key, dir)| {
        if is_key_pressed(key) {
            snake_head.dir = dir;
        }
    });
}

fn add_new_part(snake_parts: &mut Vec<SnakePart>, snake_head: &SnakeHead) {
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

fn crash_if_hit(snake_head: &SnakeHead, snake_parts: &[SnakePart]) {
    let hitbox_parts = snake_parts
        .iter()
        .skip(1)
        .map(|SnakePart { pos }| AABB::from_center_size(*pos, SNAKE_SIZE))
        .collect::<Vec<_>>();

    let head_hitbox = AABB::from_center_size(snake_head.pos, SNAKE_SIZE);

    if hitbox_parts.iter().any(|aabb| head_hitbox.intersects(aabb)) {
        println!("game over");
    }
}

fn draw_snake(snake_head: &SnakeHead, snake_parts: &[SnakePart]) {
    draw_rect(snake_head.pos, SNAKE_SIZE, Color::rgb(0.0, 0.1, 0.2), 0);
    snake_parts
        .iter()
        .enumerate()
        .map(|(i, SnakePart { pos })| (Color::rgb((i + 1) as f32 * 0.05, 0.1, 0.2), *pos))
        .for_each(|(color, pos)| {
            draw_rect(pos, SNAKE_SIZE, color, 0);
        });
}

fn move_snake(snake_head: &mut SnakeHead, snake_parts: &mut [SnakePart], speed: f32) {
    snake_head.pos += snake_head.dir * speed;
    snake_parts
        .to_owned()
        .into_iter()
        .rev()
        .skip(1)
        .chain(std::iter::once(SnakePart {
            pos: snake_head.pos,
        }))
        .zip(snake_parts.iter_mut().rev())
        .enumerate()
        .for_each(|(i, (old, new))| {
            let dir = old.pos - new.pos;
            new.pos += dir.normalize()
                * speed
                * dir
                    .length()
                    .powi(50_i32.saturating_sub(i as i32))
                    .min(dir.length());
        });
}

fn spawn_food_if_non_existent(food: &mut Option<Food>) {
    if food.is_none() {
        food.replace(Food {
            pos: random_box(Vec2::ZERO, Vec2::ONE * 10.0),
        });
    }
}

fn draw_food(food: &Option<Food>) {
    if let Some(Food { pos }) = food {
        draw_rect(*pos, SNAKE_SIZE * 0.5, Color::rgb(0.0, 1.0, 0.0), 0);
    }
}

fn despawn_food(food: &mut Option<Food>) {
    food.take();
}

fn snake_hits_food(food: &Option<Food>, snake_head: &SnakeHead) -> bool {
    food.as_ref().map_or(false, |Food { pos }| {
        let food_aabb = AABB::from_center_size(*pos, SNAKE_SIZE * 0.5);
        let snake_aabb = AABB::from_center_size(snake_head.pos, SNAKE_SIZE);
        food_aabb.intersects(&snake_aabb)
    })
}
