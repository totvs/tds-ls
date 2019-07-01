var path = require('path');

switch (process.platform) {
    case 'win32':
        module.exports = path.join(__dirname, 'bin', 'windows', 'advpls.exe');
        break;
    case 'linux':
        module.exports = path.join(__dirname, 'bin', 'linux', 'advpls');
        break;
    case 'darwin':
        module.exports = path.join(__dirname, 'bin', 'mac', 'advpls');
        break;
    default:
        throw new Error('Unsuported platform: ' + process.platform);
}

