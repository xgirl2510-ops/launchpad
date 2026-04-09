# Unity Code Review Checklist

- [ ] No GetComponent calls in Update/FixedUpdate
- [ ] Component references cached in Awake/Start
- [ ] No string-based Find calls in runtime code
- [ ] Object pooling used for frequent instantiation
- [ ] SerializeField used instead of public fields
- [ ] No magic numbers — use constants or ScriptableObjects
- [ ] Null checks on external references
- [ ] Coroutines properly stopped on disable/destroy
- [ ] No allocations in hot loops (Update, FixedUpdate)
- [ ] Events unsubscribed in OnDisable/OnDestroy
