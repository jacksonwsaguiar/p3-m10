const express = require("express");
const amqp = require("amqplib");
const fs = require("fs");
const path = require("path");
const Jimp = require("jimp");

const app = express();
app.use(express.json());

async function sendToQueue(message, queue) {
  const connection = await amqp.connect("amqp://localhost");
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

async function consumeFromQueue() {
  const connection = await amqp.connect("amqp://localhost");
  const channel = await connection.createChannel();
  const queue = "image";

  await channel.assertQueue(queue, { durable: true });

  channel.consume(queue, async (msg) => {
    if (msg !== null) {
      const content = JSON.parse(msg.content.toString());
      const { username, image, filename } = content;

      const imageBuffer = Buffer.from(image, "base64");
      const inputPath = path.join(__dirname, "processed", "input-" + filename);
      const outputPath = path.join(__dirname, "processed", "bw-" + filename);

      fs.writeFileSync(inputPath, imageBuffer);

      Jimp.read(inputPath)
        .then((img) => {
          return img
            .greyscale()
            .write(outputPath); 
        })
        .then(async () => {
          console.log(
            `Image converted to black and white and saved to ${outputPath}`
          );
          
          await sendToQueue({ action: "image-proccesed", username }, "logger");
          await sendToQueue({title: "image ready", message:"finish image conversion", username}, "notification");
       
        })
        .then(() => {
          console.log("Notification sent to", username);
          channel.ack(msg);
        })
        .catch((err) => {
          console.error("Error processing image:", err);
          channel.nack(msg);
        });
      console.log(`Image saved to ${outputPath}`);
    }
  });
}

app.listen(3002, () => {
  console.log("Notification service listening on port 3004");
  consumeFromQueue();
});
