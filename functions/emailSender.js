const axios = require("axios");
const functions = require("firebase-functions");
const apiKey = functions.config().sendgrid.key;

function formatDate(timestamp) {
  const date = timestamp.toDate();
  const year = date.getUTCFullYear();
  const month = String(date.getUTCMonth() + 1).padStart(2, '0');
  const day = String(date.getUTCDate()).padStart(2, '0');
  const hours = String(date.getUTCHours() + 9).padStart(2, '0'); 
  const minutes = String(date.getUTCMinutes()).padStart(2, '0');
  const ampm = hours >= 12 ? 'PM' : 'AM';
  return `${year}/${month}/${day} ${hours % 12}:${minutes} ${ampm}`;
}

async function sendEmail(recipientEmail, name, expiredTime, certificationName) {
  if (!apiKey) {
    throw new Error("SENDGRID_API_KEY environment variable is not set");
  }

  const apiUrl = "https://api.sendgrid.com/v3/mail/send";
  const formattedDate = formatDate(expiredTime);

  const data = {
    "personalizations": [
      {
        "to": [{"email": recipientEmail}],
        "dynamic_template_data": {
          "name": name,
          "expiredTime": formattedDate,
          "certification_name": certificationName,
        },
      },
    ],
    "from": {"email": "a.mason@pvp.co.jp"},
    "template_id": "d-9b3d5bf1242a4f479fcd781ed225e3c9",
  };

  try {
    const response = await axios.post(apiUrl, data, {
      headers: {
        "Authorization": `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
    });

    if (response.status === 202) {
      console.log("Email sent successfully");
    } else {
      console.log(`Failed to send email. Status code: ${response.status}`);
    }
  } catch (error) {
    console.error(`Error sending email: ${error}`);
  }
}

module.exports = {
  sendEmail,
};