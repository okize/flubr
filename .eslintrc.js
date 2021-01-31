module.exports = {
  root: true,
  extends: 'airbnb-base',
  env: {
    browser: true,
  },
  rules: {
    'max-len': [2, 150, 4],
    'no-console': 'off',
    'no-underscore-dangle': 'off',
    'import/no-extraneous-dependencies': ['error', { devDependencies: true }],
  },
};
