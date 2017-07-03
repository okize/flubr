import $ from 'jquery';
import isNewer from 'is-version-newer';

export default {

  getVersion(el) {
    return $.get('/api/localAppVersion', (localVersion) => {
      el.append(` ${localVersion}`);
      return $.get('/api/remoteAppVersion', (remoteVersion) => {
        if (isNewer(localVersion, remoteVersion)) {
          return el.append(`<br><small>(newer version available: ${remoteVersion})</small>`);
        }
      });
    });
  },
};
