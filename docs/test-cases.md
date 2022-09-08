| Case | $NewDistro | $ForceBootstrap | \[DistroExists\] | Action(s)                 |
| ---- | ---------- | --------------- | ---------------- | ------------------------- |
| 1    | TRUE       | TRUE            | TRUE             | throw                     |
| 2    | TRUE       | TRUE            | FALSE            | import, bootstrap, config |
| 3    | TRUE       | FALSE           | TRUE             | throw                     |
| 4    | TRUE       | FALSE           | FALSE            | import, bootstrap, config |
| 5    | FALSE      | TRUE            | TRUE             | bootstrap, config         |
| 6    | FALSE      | TRUE            | FALSE            | throw                     |
| 7    | FALSE      | FALSE           | TRUE             | config                    |
| 8    | FALSE      | FALSE           | FALSE            | throw                     |