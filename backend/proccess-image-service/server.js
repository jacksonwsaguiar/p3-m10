const express = require("express");
const amqp = require("amqplib");
const fs = require("fs");
const Jimp = require("jimp");
const multer = require("multer");

const app = express();
app.use(express.json());
const upload = multer({ dest: "uploads/" });

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

app.post("/upload", upload.single("image"), async (req, res) => {
  const username = req.body.username;
  const imagePath = req.file.path;
  await sendToQueue({ action: "image-uploaded", username }, "logger");

  try {
    const image = await Jimp.read(imagePath);
    image.greyscale();

    const buffer = await image.getBufferAsync(Jimp.MIME_JPEG);

    await sendToQueue({ action: "image-processed", username }, "logger");

    res.setHeader("Content-Type", "image/jpeg");
    res.send(buffer);

    console.log(`Image converted to black and white and sent to ${username}`);
  } catch (err) {
    console.error("Error processing image:", err);
    res.status(500).json({ message: "Error processing image" });
  } finally {
    fs.unlinkSync(imagePath); // Clean up the uploaded image file
  }
});

app.listen(3001, () => {
  console.log("Process image service listening on port 3001");
});
