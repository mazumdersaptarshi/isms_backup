/**
 * Sends an email using the SendGrid service.
 * @async
 * @returns {Promise<void>} runs when email is sent.
 */

const axios = require("axios");
const functions = require("firebase-functions");
const apiKey = functions.config().sendgrid.key;

async function sendEmail(recipientEmail) {
  if (!apiKey) {
    throw new Error("SENDGRID_API_KEY environment variable is not set");
  }
  const apiUrl = "https://api.sendgrid.com/v3/mail/send";

  const data = {
    "personalizations": [
      {
        "to": [
          {"email": recipientEmail},
        ],
      },
    ],
    "from": {"email": "a.mason@pvp.co.jp"},
    "template_id": "d-52714ade487b4b8ca6ae412c1ec53b62", // Use your template ID here

    // The "content" field is not needed when using a template, but if your template expects dynamic values,
    // you can set them with the "dynamic_template_data" field.
    "dynamic_template_data": {
      // "variableName": "value",   // Uncomment and add variables as required by your template
    },
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
