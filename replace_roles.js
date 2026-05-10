const fs = require('fs');
const path = './src/locales/en.json';
let data = JSON.parse(fs.readFileSync(path, 'utf8'));

// Recursive replace function
function replaceRole(obj) {
  for (let key in obj) {
    if (typeof obj[key] === 'string') {
      obj[key] = obj[key]
        .replace(/Pastors/g, 'Admins')
        .replace(/pastors/g, 'admins')
        .replace(/Pastor/g, 'Admin')
        .replace(/pastor/g, 'admin');
    } else if (typeof obj[key] === 'object' && obj[key] !== null) {
      replaceRole(obj[key]);
    }
  }
}

replaceRole(data);
fs.writeFileSync(path, JSON.stringify(data, null, 4));
console.log("Done");
