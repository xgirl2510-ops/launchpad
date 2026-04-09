# Unity Code Standards

## Naming Conventions
- **Classes/Structs**: PascalCase (`PlayerController`, `EnemySpawner`)
- **Methods**: PascalCase (`GetHealth()`, `TakeDamage()`)
- **Variables**: camelCase (`currentHealth`, `moveSpeed`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_HEALTH`, `DEFAULT_SPEED`)
- **Private fields**: _camelCase (`_rigidbody`, `_isAlive`)
- **Serialized fields**: camelCase with `[SerializeField]`

## Architecture
- Use ScriptableObjects for shared data/config
- Prefer composition over inheritance
- Use events/delegates for decoupled communication
- Keep MonoBehaviours thin — extract logic to plain C# classes

## Performance
- Cache component references in Awake()
- Avoid Find/GetComponent in Update()
- Use object pooling for frequently spawned objects
- Minimize allocations in hot paths
