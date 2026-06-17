# Good Project

This example project has documented public APIs and checkable examples.

## Usage

```mbt check
test {
  inspect(@good_project.add(1, 2), content="3")
}
```

## Development

```bash
moon check
moon test
```

## License

MIT

