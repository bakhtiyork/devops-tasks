const http = require('http');

const hostname = '0.0.0.0';
const port = process.env.PORT || 3000;
const devops = process.env.DEVOPS || 'Not defined.';

const server = http.createServer((req, res) => {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/html');
    res.end(`<p>DEVOPS=${devops}</p>`);
});

server.listen(port, hostname, () => {
    console.log(`Server running at http://${hostname}:${port}`);
});
