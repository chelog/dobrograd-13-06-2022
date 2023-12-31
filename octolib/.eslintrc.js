module.exports = {
	'root': true,
	env: {
		node: true,
	},
	'parser': '@typescript-eslint/parser',
	'plugins': [
		'@typescript-eslint',
	],
	'extends': [
		'eslint:recommended',
		'plugin:@typescript-eslint/eslint-recommended',
		'plugin:@typescript-eslint/recommended',
	],
	'rules': {
		'generator-star-spacing': 'off',
		'arrow-parens': 'off',
		'one-var': 'off',
		'no-void': 'off',
		'no-tabs': 'off',
		'multiline-ternary': 'off',
		'comma-dangle': ['error', 'always-multiline'],
		indent: ['error', 'tab', { SwitchCase: 1 }],
		'no-return-assign': 'off',
		'no-constant-condition': ['error', { checkLoops: false }],
		'no-extend-native': ['error', { 'exceptions': ['String'] }],
		'no-empty': ['error', { allowEmptyCatch: true }],
		'no-empty-function': 'off',
		curly: ['error', 'multi', 'consistent'],
		quotes: ['warn', 'single', { avoidEscape: true }],
		'space-before-function-paren': ['error', {
			anonymous: 'never',
			named: 'never',
			asyncArrow: 'always',
		}],
		'prefer-const': ['error', { destructuring: 'all' }],

		// 'import/first': 'off',
		// 'import/named': 'error',
		// 'import/namespace': 'error',
		// 'import/default': 'error',
		// 'import/export': 'error',
		'import/extensions': 'off',
		'import/no-unresolved': 'off',
		'import/no-extraneous-dependencies': 'off',
		'prefer-promise-reject-errors': 'off',

		'@typescript-eslint/no-explicit-any': 'off',
		'@typescript-eslint/explicit-module-boundary-types': 'off',
		'@typescript-eslint/no-empty-function': 'off',
		'@typescript-eslint/no-empty-interface': ['error', { allowSingleExtends: true }],

		'no-debugger': process.env.NODE_ENV === 'production' ? 'error' : 'off',
		'no-console': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
	},
}
