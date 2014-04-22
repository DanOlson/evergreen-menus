Beermapper.ShareTwitterComponent = Ember.Component.extend({
  tagName: 'a',
  classNames: 'twitter-share-button',
  count: 'none',
  size: 'large',
  url: 'http://beermapper.com',
  text: 'Find your favorite beer with Beer Mapper!',
  hashtags: 'beermapper',
  attributeBindings: [
    'size:data-size',
    'url:data-url',
    'text:data-text',
    'hashtags:data-hashtags',
    'count:data-count'
  ]
});
