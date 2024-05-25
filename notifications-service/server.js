const express = require('express');
// const admin = require('firebase-admin');
const amqp = require('amqplib');

const app = express();
app.use(express.json());

// const serviceAccount = require('./path/to/your-firebase-adminsdk.json'); // Baixe o arquivo JSON do Firebase

// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount),
// });

async function consumeFromQueue() {
    const connection = await amqp.connect('amqp://localhost');
    const channel = await connection.createChannel();
    const queue = 'notification';

    await channel.assertQueue(queue, {
        durable: true
    });

    channel.consume(queue, async (msg) => {
        if (msg !== null) {
            const content = JSON.parse(msg.content.toString());
            const { username,title, message } = content;

            // const fcmToken = 'user-fcm-token'; // This should be fetched based on the username

            // const notification = {
            //     token: fcmToken,
            //     notification: {
            //         title: title,
            //         body: message,
            //     },
            // };

            try {
                // await admin.messaging().send(notification);
                // console.log('Notification sent to', username);
            } catch (error) {
                console.error('Error sending notification:', error);
            }

            channel.ack(msg);
        }
    });
}

app.listen(3003, () => {
    console.log('Notification service listening on port 3004');
    consumeFromQueue();
});
