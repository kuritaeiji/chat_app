import App from '../packs/views/UsersNew.vue'

test('there is no I in team', () => {
  expect('team').not.toMatch(/I/);
});
