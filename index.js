// Setup modules
const restify = require('restify');

// Prepare global constants
const server = restify.createServer();
let greetingCount = 0;

server.get('rest', (req, res, next) => {
  res.send(200);
  next();
});

// Define routes
server.get('rest/hello/:name', (req, res, next) => {
  res.json({ message: `Hello ${req.params.name}. '/hello/:name' has been invoked ${++greetingCount} times since I was last started up.`});
  next();
});

// Start server
server.listen(8080, function() {
  console.log('%s listening at %s', server.name, server.url);
});
