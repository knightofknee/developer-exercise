const path = require('path');
const express = require('express')
// const bodyParser = require('body-parser');
const PORT = process.env.PORT || 8080;
const app = express();
const server = app.listen(PORT, () => console.log(`Feeling chatty on port ${PORT}`));


module.exports = app;
// body parsing middleware
// app.use(bodyParser.json());
// app.use(bodyParser.urlencoded({ extended: true }));

app.use(express.static(path.join(__dirname, '..', 'node_modules')));
app.use(express.static(path.join(__dirname, '..', 'public')));

// 404 middleware
app.use((req, res, next) =>
  path.extname(req.path).length > 0 ?
    res.status(404).send('Not found') :
    next()
);

// send index.html
app.use('*', (req, res, next) =>
  res.sendFile(path.join(__dirname, 'javascript/list_app/quotes.html'))
);

// error handling endware
app.use((err, req, res, next) =>
  res.status(err.status || 500).send(err.message || 'Internal server error.')
);
