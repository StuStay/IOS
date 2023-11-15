const express = require('express');
const app = express()
const connect = require('./ConfigDB/database')

require('dotenv').config();

app.use(express.json())

const PORT = process.env.PORT || 7888

app.listen(PORT , () => {

    console.log(`server runnin on port ${PORT}`);
})

connect();
app.use('/api/contrats', require('./Route/Contrat'));