module.exports = {
  default: {
    require: ['features/step_definitions/**/*.js'],
    format: [
      'json:report.json',
      '@cucumber/pretty-formatter',
    ],
  },
};
