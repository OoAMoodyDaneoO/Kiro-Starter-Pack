---
name: create-frontend-component
description: "Create a new React or frontend component with typed props, tests, styling, and documentation. Use when adding UI components to a frontend project."
---

## Description

Creates a complete frontend component with typed props, a co-located test file, and documentation. The generated component follows team conventions for file naming, styling approach, and test structure so every new component starts from a consistent baseline. Supports React, Vue, and other popular frontend frameworks.

When invoked, you'll need: the component name in PascalCase (e.g., `UserProfile`, `SearchBar`, `DataTable`), the frontend framework (`react`, `vue`, `svelte`, `angular`), and the styling approach (`css-modules`, `tailwind`, `styled-components`, `scss`, `plain-css`). Optionally specify a target directory (default: `src/components/<ComponentName>/`) and whether to generate a Storybook story file.

## Steps

1. **Create component file** — Generate the main component file in the target directory:
   - Use the framework-appropriate file extension (e.g., `.tsx` for React, `.vue` for Vue, `.svelte` for Svelte)
   - Include a module-level doc comment describing the component's purpose
   - Export the component as the default export (or named export per project convention)
   - Add a placeholder render body with semantic HTML structure

2. **Add props and types** — Define the component's prop interface and types:
   - Create a typed props interface (e.g., `interface <ComponentName>Props` for React/TypeScript, `defineProps` for Vue 3)
   - Include common starter props: `className` (optional), `children` (if applicable), and one domain-specific example prop
   - Add JSDoc or equivalent comments on each prop describing its purpose and default value
   - Set sensible default values for optional props

3. **Add styling** — Generate the style file matching the chosen styling approach:
   - For CSS Modules: create `<ComponentName>.module.css` with a root class selector
   - For Tailwind: add utility classes directly in the component markup
   - For Styled Components: create styled wrappers in a `<ComponentName>.styles.ts` file
   - For SCSS: create `<ComponentName>.module.scss` with a root class and BEM-ready structure
   - For Plain CSS: create `<ComponentName>.css` with a scoped root class
   - Import the style file in the component

4. **Create test file** — Generate a co-located test file for the component:
   - Name the file `<ComponentName>.test.tsx` (or framework-appropriate extension)
   - Include a `describe` block named after the component
   - Add a rendering test that verifies the component mounts without errors
   - Add a props test that verifies custom props are applied correctly
   - Add an accessibility test that checks for basic ARIA compliance (e.g., role attributes)
   - Use the project's test framework (Jest, Vitest, or Testing Library)

5. **Add documentation** — Generate inline and file-level documentation:
   - Add a JSDoc block at the top of the component file with a description, `@param` for each prop, and a `@example` usage snippet
   - Create an `index.ts` barrel file that re-exports the component for clean imports
   - If `with_stories` is true, generate a `<ComponentName>.stories.tsx` Storybook file with a default story and one variant

## Expected Output

A component directory at `<directory>/<ComponentName>/` containing the component source file, typed props, a style file, a co-located test file, and a barrel `index.ts` export. The component renders without errors, tests pass, and the module can be imported from its directory path immediately.

## Notes

- The generated component is intentionally minimal. Add state management, hooks, or API calls after scaffolding.
- For React projects, the skill generates functional components with hooks. Class components are not supported.
- The test file uses Testing Library patterns by default. Swap to Enzyme or framework-native testing if your project requires it.
- If your project uses a component library (e.g., MUI, Ant Design, Chakra), update the generated markup to use library primitives.
- The barrel `index.ts` file simplifies imports — e.g., `import { UserProfile } from '@/components/UserProfile'` instead of referencing the file directly.
- Adjust the default directory to match your project's component folder convention (e.g., `src/ui/`, `app/components/`).