const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

const app = express();
const port = 3000;

app.use(bodyParser.json());


mongoose.connect('mongodb+srv://shaikhmohammodsm:agEvP8yqaprZL8WY@rapid.eipvb4a.mongodb.net/?retryWrites=true&w=majority&appName=rapid');
const db = mongoose.connection;
db.on('error', (error) => console.error(error));
db.once('open', () => console.log('Connected to Database'));


// app.delete('/:id', async (req, res) => {
//   const id = req.params.id;
//  await User.findByIdAndDelete(id);
//   res.json('Delete successfully');
// });


// ...existing code...

app.put('/:id', async (req, res) => {
  try {
    const { name, age, email } = req.body;
    const updatedUser = await User.findByIdAndUpdate(
      req.params.id,
      { name, age, email },
      { new: true }
    );
    if (!updatedUser) {
      return res.status(404).json({ message: 'User not found' });
    }
    res.json(updatedUser);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ...existing code...

// ...existing code...

app.get('/', async (req, res) => {
  try {
    const users = await User.find();
    res.json(users);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ...existing code...


app.post('/', (req, res) => {

  const { name, age, email } = req.body;
  const newUser = new User({ name: name, age: age, email: email });
  newUser.save();
  res.json({ message: 'User created successfully', user: newUser });

  // const bodayData = req.body
  // const username = req.body.username
  // const id = req.params.id
  // console.log(id);
  // if(username=="Bala"){
  //   res.json("User is able to log in");
  // }else{
  //   res.json("User is Not-able to log in");
  // }

  // console.log(username);

  // res.json("Hi There That applicaiton is same working as node mone ");
//  console.log("Hy Shaikh Mohammed That App is working as excepted")
});
//TODO:  this


app.listen(port, () => {
  console.log(`Server is running on :${port}`);
});



const { Schema, model } = mongoose;
const userSchema = new Schema({
  name: String,
  age: Number,
  email: String
});
const User = model('User', userSchema);