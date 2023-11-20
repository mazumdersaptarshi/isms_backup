const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {sendEmail} = require("./emailSender");

admin.initializeApp();

exports.scheduledEmailFunction = functions.pubsub
    .schedule("every 5 minutes")
    .onRun(async () => {
      const now = admin.firestore.Timestamp.now();
      const adminsRef = admin
          .firestore()
          .collection("adminconsole")
          .doc("allAdmins")
          .collection("admins");
      const snapshot = await adminsRef.get();

      await Promise.all(
          snapshot.docs.map(async (doc) => {
            const data = doc.data();
            const email = data.email;
            const name = data.name;
            const certifications = data.certifications || [];

            for (const certification of certifications) {
              const expiredTime = certification.expiredTime;

              if (expiredTime) {
                const timeDifference = expiredTime.toMillis() - now.toMillis();

                if (timeDifference <= 86400000 && timeDifference > 0) {
                  if (!certification.reminderSent) {
                    await sendEmail(
                        email,
                        name,
                        expiredTime,
                        certification.certification_name,
                    );

                    // Mark reminderSent as true inside the certification map
                    const certificationIndex =
                    certifications.indexOf(certification);
                    certifications[certificationIndex].reminderSent = true;

                    await doc.ref.update({
                      certifications: certifications,
                    });
                  } else {
                    console.log("Reminder has already been sent to", email);
                  }
                }
              } else {
                console.log("Expired Time is undefined for certification:",
                    certification);
              }
            }
          }),
      );
      return null;
    });
