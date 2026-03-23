# Redmine Project Header Plugin

Adds an **`X-Project`** HTTP response header to every Redmine **Issues** request.  
The header value is the **name** of the project that scopes the request.

## Compatibility

| Redmine | Ruby   |
|---------|--------|
| 5.x     | 3.1+   |

## Installation

1. Copy (or clone) this directory into your Redmine `plugins/` folder and name
   it **`redmine_project_header`**:

   ```bash
   cd /path/to/redmine/plugins
   git clone git@github.com:baskakov/redmine_project_header.git redmine_project_header
   ```

2. Restart Redmine (Passenger reload, `systemctl restart redmine`, etc.).

   No database migration is required — this plugin adds no database tables.

## How it works

The plugin **prepends** a module into `IssuesController` that registers an
`after_action` callback.  After every action in that controller completes, the
callback checks whether `@project` is set and, if so, writes the project name
into the response header `X-Project`.

```
GET /projects/my-project/issues   →   X-Project: My Project
GET /issues/42                    →   X-Project: My Project
GET /issues                       →   (header absent — no project scope)
```

## Running the tests

From the Redmine root directory:

```bash
bundle exec rake redmine:plugins:test NAME=redmine_project_header
```

## License

MIT — see [LICENSE](LICENSE).

