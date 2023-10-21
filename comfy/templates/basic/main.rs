use comfy::*;

// This example shows an integration between comfy and blobs, a simple 2d physics engine. It's not
// the most beautiful example, and maybe a bit verbose for what it does, but it tries to showcase
// some more extensible ways of using comfy.
comfy_game!(
    "Physics Example",
    GameContext,
    GameState,
    make_context,
    setup,
    update
);
