---
title: "5m. promise 관련 eslint rules"
---

https://twitter.com/tommoor/status/1675150188908822530?s=46&t=WWPMzoEtNZZ_eqp7T45DPQ

![[notes/images/Pasted image 20230801152504.png]]

```
// .eslintignore
*.js
```

```json
// .eslintrc.json
{
  "parser": "@typescript-eslint/parser",  
  "parserOptions": {  
    "project": ["./tsconfig.json"]  
  },
  "rules": {
    "@typescript-eslint/no-floating-promises": "error",  
    "@typescript-eslint/await-thenable":"error",  
    "@typescript-eslint/no-misused-promises": "error"
  }
}
```