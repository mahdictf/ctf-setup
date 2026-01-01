# Custom Features

Add your own custom features here!

## How to Add

1. Create `.sh` file in this directory
2. Add your functions/aliases
3. Enable in config.conf: `ALIASES_CUSTOM=true`
4. Run installer or reload shell

## Example

`custom/my-feature.sh`:

```bash
#!/bin/bash
my_command() {
    echo "Hello!"
}
alias mycmd='my_command'
```
