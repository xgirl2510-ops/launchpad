# Three.js Code Standards

## Naming
- **Classes**: PascalCase (`PlayerController`, `SceneManager`)
- **Functions/methods**: camelCase (`updatePosition`, `loadAssets`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_SPEED`, `GRAVITY`)
- **Files**: kebab-case (`player-controller.ts`, `scene-manager.ts`)

## Architecture
- Separate game logic from rendering
- Use ECS or component pattern for game objects
- Centralize asset loading with a manager
- Dispose Three.js resources on cleanup (geometries, materials, textures)

## Performance
- Reuse geometries and materials
- Use instanced meshes for repeated objects
- Implement frustum culling
- Use LOD for complex scenes
- Minimize draw calls via merging/batching
