const express = require("express");
const mongoose = require("mongoose");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const amqp = require("amqplib");

const app = express();
app.use(express.json());

mongoose.connect("mongodb+srv://jacksonaguiar:fGZAQgHzjlyIXcSJ@cluster0.zkykwzk.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0", {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const UserSchema = new mongoose.Schema({
  username: String,
  password: String,
});

const User = mongoose.model("User", UserSchema);

async function sendToQueue(message, queue) {
  const connection = await amqp.connect("amqp://rabbitmq");
  const channel = await connection.createChannel();

  await channel.assertQueue(queue, {
    durable: true,
  });

  channel.sendToQueue(queue, Buffer.from(JSON.stringify(message)));
  console.log("Message sent to queue:", message);

  setTimeout(() => {
    connection.close();
  }, 500);
}

app.post("/register", async (req, res) => {
  const { username, password } = req.body;

  const hashedPassword = await bcrypt.hash(password, 10);
  const user = new User({ username, password: hashedPassword });
  await user.save();

  sendToQueue({ action: "create_account", username }, "logger");

  res.status(201).json("User created");
});

app.post("/login", async (req, res) => {
  const { username, password } = req.body;
  const user = await User.findOne({ username });

  const passValid = bcrypt.compare(password, user.password);

  if (user && passValid) {
    const token = jwt.sign({ username }, "secret");

    sendToQueue({ action: "login", username }, "logger");

    res.json({ token });
  } else {
    res.status(401).send("Invalid credentials");
  }
});

app.listen(3000, () => {
  console.log("User service listening on port 3000");
});
