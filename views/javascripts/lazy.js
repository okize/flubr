export default function (selector) {
  // replace empty image source with data-src value
  const loadImage = function (el, cb) {
    const img = new Image();
    const src = el.getAttribute('data-src');
    img.onload = function () {
      if (!imageLoaded(el)) {
        el.src = src;
        el.className = `${el.getAttribute('class')} loaded`;
        if (cb) { return cb(); } return null;
      }
    };
    return img.src = src;
  };

  // check if image has a class called 'loaded'
  const imageLoaded = (el) => el.className.indexOf('loaded') > -1;

  // check if image is visible in viewport
  const imageInView = function (el) {
    const rect = el.getBoundingClientRect();
    return (rect.top >= 0) && (rect.left >= 0) && (rect.top <= window.innerHeight);
  };

  return window.addEventListener('load', () => {
    const images = document.querySelectorAll(`img.${selector || 'lazy'}`);

    const processScroll = () => (() => {
      const result = [];
      for (const image of Array.from(images)) {
        let item;
        if (imageInView(image)) {
          item = loadImage(image);
        }
        result.push(item);
      }
      return result;
    })();

    processScroll();

    // register processScroll event
    return window.addEventListener('scroll', processScroll, false);
  });
}
