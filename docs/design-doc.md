# Design Doc
---
## Host config
---
TBA

## Vagrantfile
---
```
for each entry in hosts array {
  set hostname
  set IP
  set VB properties like {
    name
    group
    GUI
    memory
    CPU
  }
  for script in host-script-array {
    execute script
  }
}
```
