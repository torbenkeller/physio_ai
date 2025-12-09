import js from '@eslint/js'
import globals from 'globals'
import reactHooks from 'eslint-plugin-react-hooks'
import reactRefresh from 'eslint-plugin-react-refresh'
import boundaries from 'eslint-plugin-boundaries'
import tseslint from 'typescript-eslint'
import { defineConfig, globalIgnores } from 'eslint/config'

export default defineConfig([
  globalIgnores(['dist']),
  {
    files: ['**/*.{ts,tsx}'],
    extends: [
      js.configs.recommended,
      tseslint.configs.recommended,
      reactHooks.configs.flat.recommended,
      reactRefresh.configs.vite,
    ],
    languageOptions: {
      ecmaVersion: 2020,
      globals: globals.browser,
    },
  },

  // Module Boundary Rules
  {
    files: ['src/**/*.{ts,tsx}'],
    plugins: {
      boundaries,
    },
    settings: {
      // Resolver for @/ path aliases
      'import/resolver': {
        typescript: {
          alwaysTryTypes: true,
          project: './tsconfig.app.json',
        },
      },
      // Dependency nodes patterns (for analyzing imports with @/ alias)
      'boundaries/dependency-nodes': ['import', 'dynamic-import'],
      'boundaries/include': ['src/**/*'],
      'boundaries/elements': [
        // App layer
        {
          type: 'app',
          pattern: 'src/app/*',
          mode: 'file',
        },
        // Shared layer
        {
          type: 'shared',
          pattern: 'src/shared/**/*',
          mode: 'file',
        },
        // Feature PUBLIC parts (can be imported cross-feature)
        {
          type: 'feature-api',
          pattern: 'src/features/*/api/*',
          mode: 'full',
          capture: ['featureName'],
        },
        {
          type: 'feature-components',
          pattern: 'src/features/*/components/*',
          mode: 'full',
          capture: ['featureName'],
        },
        {
          type: 'feature-types',
          pattern: 'src/features/*/types/*',
          mode: 'full',
          capture: ['featureName'],
        },
        // Feature PRIVATE parts (internal only!)
        {
          type: 'feature-hooks',
          pattern: 'src/features/*/hooks/*',
          mode: 'full',
          capture: ['featureName'],
        },
        {
          type: 'feature-utils',
          pattern: 'src/features/*/utils/*',
          mode: 'full',
          capture: ['featureName'],
        },
        {
          type: 'feature-slices',
          pattern: 'src/features/*/slices/*',
          mode: 'full',
          capture: ['featureName'],
        },
      ],
    },
    rules: {
      // Enforce module boundaries
      // Rule: Disallow importing PRIVATE feature parts (hooks, utils, slices) from OTHER features
      'boundaries/element-types': [
        'error',
        {
          // By default, allow all imports (we only want to restrict specific patterns)
          default: 'allow',
          rules: [
            // FORBIDDEN: Shared cannot import from any feature
            {
              from: ['shared'],
              disallow: [
                'feature-api',
                'feature-components',
                'feature-types',
                'feature-hooks',
                'feature-utils',
                'feature-slices',
              ],
              message:
                'Shared modules cannot import from features. Move the dependency to shared or keep it in the feature.',
            },

            // FORBIDDEN: Features cannot import PRIVATE parts (hooks, utils, slices) from OTHER features
            {
              from: [['feature-api', { featureName: '*' }]],
              disallow: [
                ['feature-hooks', { featureName: '!${featureName}' }],
                ['feature-utils', { featureName: '!${featureName}' }],
                ['feature-slices', { featureName: '!${featureName}' }],
              ],
              message:
                'Cross-feature imports of hooks/utils/slices are forbidden (tight coupling). Only import api/, components/, or types/ from other features.',
            },
            {
              from: [['feature-components', { featureName: '*' }]],
              disallow: [
                ['feature-hooks', { featureName: '!${featureName}' }],
                ['feature-utils', { featureName: '!${featureName}' }],
                ['feature-slices', { featureName: '!${featureName}' }],
              ],
              message:
                'Cross-feature imports of hooks/utils/slices are forbidden (tight coupling). Only import api/, components/, or types/ from other features.',
            },
            {
              from: [['feature-types', { featureName: '*' }]],
              disallow: [
                ['feature-hooks', { featureName: '!${featureName}' }],
                ['feature-utils', { featureName: '!${featureName}' }],
                ['feature-slices', { featureName: '!${featureName}' }],
              ],
              message:
                'Cross-feature imports of hooks/utils/slices are forbidden (tight coupling). Only import api/, components/, or types/ from other features.',
            },

            // FORBIDDEN: Private feature parts cannot import from OTHER features at all
            {
              from: [['feature-hooks', { featureName: '*' }]],
              disallow: [
                ['feature-api', { featureName: '!${featureName}' }],
                ['feature-components', { featureName: '!${featureName}' }],
                ['feature-types', { featureName: '!${featureName}' }],
                ['feature-hooks', { featureName: '!${featureName}' }],
                ['feature-utils', { featureName: '!${featureName}' }],
                ['feature-slices', { featureName: '!${featureName}' }],
              ],
              message:
                'Private feature parts (hooks/utils/slices) cannot import from other features. Keep them isolated within the feature.',
            },
            {
              from: [['feature-utils', { featureName: '*' }]],
              disallow: [
                ['feature-api', { featureName: '!${featureName}' }],
                ['feature-components', { featureName: '!${featureName}' }],
                ['feature-types', { featureName: '!${featureName}' }],
                ['feature-hooks', { featureName: '!${featureName}' }],
                ['feature-utils', { featureName: '!${featureName}' }],
                ['feature-slices', { featureName: '!${featureName}' }],
              ],
              message:
                'Private feature parts (hooks/utils/slices) cannot import from other features. Keep them isolated within the feature.',
            },
            {
              from: [['feature-slices', { featureName: '*' }]],
              disallow: [
                ['feature-api', { featureName: '!${featureName}' }],
                ['feature-components', { featureName: '!${featureName}' }],
                ['feature-types', { featureName: '!${featureName}' }],
                ['feature-hooks', { featureName: '!${featureName}' }],
                ['feature-utils', { featureName: '!${featureName}' }],
                ['feature-slices', { featureName: '!${featureName}' }],
              ],
              message:
                'Private feature parts (hooks/utils/slices) cannot import from other features. Keep them isolated within the feature.',
            },
          ],
        },
      ],
    },
  },
])
