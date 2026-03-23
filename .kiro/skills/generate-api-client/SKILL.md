---
name: generate-api-client
description: "Generate typed API client code from an OpenAPI specification with models, service classes, and usage examples. Use when consuming a REST API."
---

## Description

Generates a complete, typed API client library from an OpenAPI (Swagger) specification file. The skill reads the spec, extracts endpoint definitions and schema models, then produces client service classes, type definitions, and usage examples in the target language. The generated client handles request construction, response parsing, and error mapping so consumers can call API endpoints with typed inputs and outputs.

When invoked, you'll need: the path to the OpenAPI specification file (JSON or YAML), the target programming language (e.g., `typescript`, `python`, `java`, `go`), and the output directory for generated code. Optionally specify a base URL (extracted from spec if omitted) and authentication strategy (`bearer`, `api-key`, `oauth2`, `none`; default: `bearer`).

## Steps

1. **Parse OpenAPI spec** — Read and validate the specification file:
   - Load the OpenAPI document (JSON or YAML)
   - Validate the spec conforms to OpenAPI 3.0 or 3.1 schema structure
   - Extract API metadata: title, version, base URL, and authentication schemes
   - Build an inventory of all paths, operations, parameters, request bodies, and response schemas
   - Resolve `$ref` references and inline shared component schemas for downstream steps

2. **Generate type definitions** — Create types and models for all schemas:
   - Generate a type or class for each schema defined in `components/schemas`
   - Map OpenAPI types to language-native types (e.g., `string` → `string`, `integer` → `number`/`int`, `array` → `T[]`/`List[T]`)
   - Handle enums, nullable fields, and nested object types
   - Generate request parameter types for operations with complex query or body parameters
   - Generate response types for each operation's success and error responses
   - Place all type definitions in a `models` subdirectory within the output directory

3. **Generate client service classes** — Create a service class for each API tag or endpoint group:
   - Group operations by their OpenAPI `tags` (or by path prefix if untagged)
   - Generate one service class per group — e.g., `UsersService`, `OrdersService`
   - Each method maps to one API operation with typed parameters and return type
   - Construct the full request URL from base URL, path, and path parameters
   - Serialize query parameters, headers, and request bodies according to the spec
   - Parse response bodies into the corresponding generated types
   - Map HTTP error status codes to typed error classes with descriptive messages
   - Generate a top-level client entry point that aggregates all service classes

4. **Add authentication and configuration** — Wire up auth and client configuration:
   - Generate a client configuration type with fields for base URL, auth credentials, timeout, and custom headers
   - Implement the selected authentication strategy — attach Bearer tokens, API key headers, or OAuth2 token refresh logic
   - Add a factory function or constructor that accepts configuration and returns a ready-to-use client instance
   - Default to the base URL from the spec; allow runtime override via configuration

5. **Generate usage examples** — Create a documented example file showing how to use the client:
   - Import the generated client and configuration types
   - Show how to instantiate the client with authentication credentials
   - Demonstrate calling at least two representative endpoints with typed inputs
   - Show how to handle success responses and typed errors
   - Place the example file at the output directory's `examples/` subdirectory with inline comments explaining each step

## Expected Output

A generated API client library at the output directory containing:
- `models/` — Type definitions for all request and response schemas
- `services/` — Service classes with typed methods for each API operation
- `client.<ext>` — Top-level client entry point aggregating all services
- `config.<ext>` — Configuration and authentication setup
- `examples/` — Usage examples with inline documentation

The client compiles without errors, has full type coverage, and is ready to import and use immediately.

## Notes

- The generated client uses the language's standard HTTP library by default (e.g., `fetch` for TypeScript, `requests` for Python, `net/http` for Go). Swap it for your preferred HTTP client after generation.
- For specs with many endpoints, consider generating only a subset by filtering on tags before invoking the skill.
- The generated types are a direct mapping from the OpenAPI schemas. If your API uses polymorphism (`oneOf`, `anyOf`, `discriminator`), review the generated union types for correctness.
- Re-run this skill when the OpenAPI spec is updated to regenerate the client. Diff the output against the previous version to review changes.
- The authentication implementation is intentionally minimal. For production use, add token caching, automatic refresh, and retry logic on 401 responses.
- If the spec includes webhook definitions, they are skipped by default. Extend the generated client manually to handle inbound webhook payloads.