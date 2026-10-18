---
name: Write Tests
interaction: chat
description: Write tests for the current buffer
opts:
  alias: tests
tools:
  - read_file
  - file_search
  - create_file
---

## user

Write tests for #{buffer}. Match the test framework and conventions already used in the project.
