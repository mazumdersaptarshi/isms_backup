const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {sendEmail} = require("./emailSender");

admin.initializeApp();

exports.scheduledEmailFunction = functions.pubsub.
    schedule("every 5 minutes").onRun(async () => {
      const now = admin.firestore.Timestamp.now();
      const adminsRef = admin.firestore().collection("adminconsole")
          .doc("allAdmins").collection("admins");
      const snapshot = await adminsRef.get();

      await Promise.all(snapshot.docs.map(async (doc) => {
        const data = doc.data();
        const expiredTime = data.expiredTime;
        const email = data.email;
        const timeDifference = expiredTime.toMillis() - now.toMillis();

        if (timeDifference <= 86400000 && timeDifference > 0) {
          if (!data.reminderSent) {
            await sendEmail(email);
            await doc.ref.update({reminderSent: true});
          } else {
            console.log("Reminder has already been sent to", email);
          }
        }
      }));
      return null;
    });
